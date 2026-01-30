#!/bin/bash

# Bootstrap Kubernetes Infrastructure Components
# This script installs NGINX Ingress Controller, cert-manager, and other essential components

set -e

echo "🚀 Bootstrapping Kubernetes Infrastructure Components..."

# Check if helm is installed
if ! command -v helm &> /dev/null; then
    echo "❌ Helm is not installed. Please install Helm first."
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check cluster connectivity
echo "🔍 Checking cluster connectivity..."
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster. Please check your kubeconfig."
    exit 1
fi

echo "✅ Connected to cluster: $(kubectl config current-context)"

# Add Helm repositories
echo "📦 Adding Helm repositories..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install NGINX Ingress Controller
echo "🌐 Installing NGINX Ingress Controller..."
kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --values k8s/bootstrap/nginx-values.yaml \
  --wait \
  --timeout 300s

# Wait for NGINX Ingress Controller to be ready
echo "⏳ Waiting for NGINX Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

# Install cert-manager
echo "🔐 Installing cert-manager..."
kubectl create namespace cert-manager --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --values k8s/bootstrap/cert-manager-values.yaml \
  --wait \
  --timeout 300s

# Wait for cert-manager to be ready
echo "⏳ Waiting for cert-manager to be ready..."
kubectl wait --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=cert-manager \
  --timeout=300s

# Apply ClusterIssuer
echo "📜 Creating ClusterIssuer for Let's Encrypt..."
kubectl apply -f k8s/bootstrap/cluster-issuer.yaml

# Install metrics-server if not present
echo "📊 Checking metrics-server..."
if ! kubectl get deployment metrics-server -n kube-system &> /dev/null; then
    echo "📊 Installing metrics-server..."
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    
    # Patch metrics-server for development environments
    kubectl patch deployment metrics-server -n kube-system --type='json' \
      -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]' || true
fi

# Verify installations
echo "🔍 Verifying installations..."
echo "NGINX Ingress Controller:"
kubectl get pods -n ingress-nginx
echo ""
echo "cert-manager:"
kubectl get pods -n cert-manager
echo ""
echo "ClusterIssuers:"
kubectl get clusterissuers
echo ""

# Get LoadBalancer IP
echo "🌐 Getting LoadBalancer IP..."
EXTERNAL_IP=""
while [ -z $EXTERNAL_IP ]; do
    echo "Waiting for external IP..."
    EXTERNAL_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
    [ -z "$EXTERNAL_IP" ] && sleep 10
done

echo "✅ Bootstrap completed successfully!"
echo "📋 Summary:"
echo "  - NGINX Ingress Controller: ✅ Installed"
echo "  - cert-manager: ✅ Installed"
echo "  - ClusterIssuer: ✅ Created"
echo "  - metrics-server: ✅ Verified"
echo "  - External IP: $EXTERNAL_IP"
echo ""
echo "🎯 Next steps:"
echo "  1. Update your DNS to point to: $EXTERNAL_IP"
echo "  2. Update ingress.yaml with your domain"
echo "  3. Deploy your application: kubectl apply -f k8s/"
echo ""
echo "📚 Useful commands:"
echo "  - Check ingress: kubectl get ingress -A"
echo "  - Check certificates: kubectl get certificates -A"
echo "  - Check cert-manager logs: kubectl logs -n cert-manager -l app.kubernetes.io/name=cert-manager"
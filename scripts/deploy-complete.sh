#!/bin/bash

# Complete deployment script for Kubernetes application
# Usage: ./deploy-complete.sh [image-tag]

set -e

IMAGE_TAG=${1:-latest}
NAMESPACE="devsu-demo"

echo "🚀 Complete Kubernetes Deployment Pipeline"
echo "Image tag: $IMAGE_TAG"

# Step 1: Bootstrap infrastructure components
echo "📦 Step 1: Bootstrapping Kubernetes infrastructure..."
if ! kubectl get namespace ingress-nginx &> /dev/null; then
    echo "Installing infrastructure components..."
    chmod +x scripts/bootstrap-k8s.sh
    ./scripts/bootstrap-k8s.sh
else
    echo "✅ Infrastructure components already installed"
fi

# Step 2: Update image tag
echo "🔧 Step 2: Updating image tag in deployment..."
sed -i "s|IMAGE_TAG|$IMAGE_TAG|g" k8s/deployment.yaml

# Step 3: Deploy application
echo "📦 Step 3: Deploying application..."
kubectl apply -f k8s/

# Step 4: Wait for deployment
echo "⏳ Step 4: Waiting for deployment to be ready..."
kubectl rollout status deployment/devsu-demo-app -n $NAMESPACE --timeout=300s

# Step 5: Verify deployment
echo "🔍 Step 5: Verifying deployment..."
kubectl get all -n $NAMESPACE
kubectl get ingress -n $NAMESPACE

# Step 6: Get application URL
echo "🌐 Step 6: Getting application URL..."
INGRESS_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ ! -z "$INGRESS_IP" ]; then
    echo "✅ Deployment completed successfully!"
    echo "📋 Application Details:"
    echo "  - External IP: $INGRESS_IP"
    echo "  - Health Check: http://$INGRESS_IP/health"
    echo "  - API Endpoint: http://$INGRESS_IP/api/users"
    echo ""
    echo "🔧 DNS Configuration:"
    echo "  Point your domain to: $INGRESS_IP"
    echo "  Update k8s/ingress.yaml with your domain"
else
    echo "⏳ External IP not yet assigned. Check with: kubectl get svc -n ingress-nginx"
fi
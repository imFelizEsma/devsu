#!/bin/bash

# Deploy Azure Infrastructure with Terraform
# Usage: ./deploy-infrastructure.sh [environment]

set -e

ENVIRONMENT=${1:-production}
TERRAFORM_DIR="./terraform"

echo "🚀 Deploying infrastructure for environment: $ENVIRONMENT"

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install it first."
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install it first."
    exit 1
fi

# Login to Azure (if not already logged in)
echo "🔐 Checking Azure authentication..."
if ! az account show &> /dev/null; then
    echo "Please login to Azure:"
    az login
fi

# Initialize Terraform
echo "🔧 Initializing Terraform..."
cd $TERRAFORM_DIR
terraform init

# Plan the deployment
echo "📋 Planning Terraform deployment..."
terraform plan -var-file="environments/${ENVIRONMENT}.tfvars" -out=tfplan

# Apply the deployment
echo "🚀 Applying Terraform deployment..."
terraform apply tfplan

# Get outputs
echo "📊 Getting deployment outputs..."
terraform output

echo "✅ Infrastructure deployment completed successfully!"

# Get AKS credentials
RESOURCE_GROUP=$(terraform output -raw resource_group_name)
CLUSTER_NAME=$(terraform output -raw aks_cluster_name)

echo "🔑 Getting AKS credentials..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing

echo "✅ Deployment completed! You can now deploy the application to Kubernetes."
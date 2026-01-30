.PHONY: help build test security-scan deploy-infra deploy-app clean bootstrap-k8s deploy-complete

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install dependencies
	npm ci

build: ## Build Docker image
	docker build -t devsu-demo-nodejs:latest .

test: ## Run tests
	npm test

test-coverage: ## Run tests with coverage
	npm test -- --coverage

security-scan: ## Run security scan
	npm audit --audit-level high
	docker run --rm -v $(PWD):/app -w /app aquasec/trivy fs .

deploy-infra: ## Deploy infrastructure with Terraform
	cd terraform && terraform init && terraform plan -var-file="environments/production.tfvars" && terraform apply -var-file="environments/production.tfvars"

bootstrap-k8s: ## Bootstrap Kubernetes infrastructure components
	chmod +x scripts/bootstrap-k8s.sh
	./scripts/bootstrap-k8s.sh

deploy-complete: ## Complete deployment (infrastructure + app)
	chmod +x scripts/deploy-complete.sh
	./scripts/deploy-complete.sh latest

local-run: ## Run application locally
	docker-compose up -d

local-stop: ## Stop local application
	docker-compose down

clean: ## Clean up resources
	docker-compose down -v
	docker system prune -f

status: ## Show deployment status
	kubectl get all -n devsu-demo

get-external-ip: ## Get external IP address
	kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
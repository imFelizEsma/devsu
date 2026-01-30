# 🔧 Configuration Checklist

## Required Changes Before Deployment

### 1. GitHub Secrets Configuration
```
AZURE_CREDENTIALS - Azure Service Principal JSON
ACR_USERNAME - Container Registry Username  
ACR_PASSWORD - Container Registry Password
SONAR_TOKEN - SonarCloud Token
SNYK_TOKEN - Snyk Security Token
```

### 2. Domain Configuration
- Update `k8s/ingress.yaml`: Replace `devsu-demo.CHANGE-THIS-DOMAIN.com`
- Update `k8s/bootstrap/cluster-issuer.yaml`: Replace `CHANGE-THIS@yourdomain.com`

### 3. Azure Resources Names
- Update `terraform/environments/production.tfvars`:
  - `resource_group_name`
  - `project_name` (must be globally unique for ACR)

### 4. Container Registry
- Update `.github/workflows/ci-cd.yml`: Replace `devsudemoregistry.azurecr.io`
- Update `k8s/deployment.yaml`: Replace registry URL

### 5. SonarCloud Configuration
- Update `sonar-project.properties`: Replace `your-org`

## Deployment Order

1. **Infrastructure First**:
   ```bash
   # Trigger infrastructure pipeline
   git push origin main  # (with terraform changes)
   ```

2. **Application Second**:
   ```bash
   # Trigger application pipeline  
   git push origin main  # (with app changes)
   ```

## Manual Steps After Infrastructure

1. **Get External IP**:
   ```bash
   kubectl get svc ingress-nginx-controller -n ingress-nginx
   ```

2. **Configure DNS**:
   - Point your domain A record to the external IP

3. **Switch to Production Certificates**:
   - Change `letsencrypt-staging` to `letsencrypt-prod` in ingress.yaml
resource_group_name = "devsu-demo-prod-rg"
location            = "East US"
project_name        = "imfeldevsu"
kubernetes_version  = "1.28.103"
node_count          = 3
vm_size             = "Standard_D2s_v3"
letsencrypt_email   = "imfelizesma@outlook.com"

tags = {
  Environment = "production"
  Project     = "devsu-demo"
  ManagedBy   = "terraform"
}
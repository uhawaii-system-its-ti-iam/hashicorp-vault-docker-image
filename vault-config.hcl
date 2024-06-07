# vault-config.hcl -

# Enable the web UI
ui = true

# Vault server listener configuration
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1  # TLS is disabled for simplicity in development environments
}

# Configure the file storage backend
storage "file" {
  path = "/vault/data"
}

# Set the maximum lease TTL for all secrets
default_lease_ttl = "768h"  # 32 days
max_lease_ttl     = "768h"  # 32 days

# API configuration
api_addr = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"

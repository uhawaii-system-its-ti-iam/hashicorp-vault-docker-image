# vault-config.hcl - configure vault for dev

# Enable the web UI.
ui = true

# Vault server listener configuration.
#  - TLS is disabled for simplicity in dev environments.
listener "tcp" {
  address     = "127.0.0.0:8200"
  tls_disable = 1
}

# Configure the file storage backend.
storage "file" {
  path = "/vault/data"
}

# Set the maximum lease TTL for all secrets to 32 days.
default_lease_ttl = "768h"
max_lease_ttl     = "768h"

# API configuration.
api_addr     = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"

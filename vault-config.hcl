# vault-config.hcl - configure vault for dev

# Enable the web UI.
ui = true
disable_mlock = true

# Vault server listener configuration.
#  - okay to disable TLS in dev environments.
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

# Configure the file storage backend.
storage "file" {
  path = "/vault/data"
  node_id = "node1"
}

# Set the maximum lease TTL for all secrets to 32 days.
default_lease_ttl = "768h"
max_lease_ttl     = "768h"

# API configuration.
api_addr     = "http://127.0.0.1:8200"

#!/bin/bash

# setup-app-token.sh - set up the token

# Once the groupings-vault container is running use this script to set up an
# application policy and token to be used when deploying the UH GROUPINGS
# container.

VAULT_ADDR="http://0.0.0.0:8200"
ROOT_TOKEN="your-root-token"
POLICY_NAME="uh-groupings-policy"
POLICY_FILE="${POLICY_NAME}.hcl"
SECRET_PATH="secret/data/uh-groupings/config"

# Create the policy file.
cat <<EOF >$POLICY_FILE
path "$SECRET_PATH" {
  capabilities = ["read"]
}
EOF

echo "Created policy file:"
cat $POLICY_FILE

# Log in to Vault.
export VAULT_ADDR=$VAULT_ADDR
vault login $ROOT_TOKEN

# Upload the policy to Vault.
vault policy write $POLICY_NAME $POLICY_FILE

# Generate a token with the specified policy.
TOKEN_RESPONSE=$(vault token create -policy="$POLICY_NAME" -format=json)

# Extract and display the client token from the response.
NEW_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.auth.client_token')
echo "Generated token with read access: $NEW_TOKEN"

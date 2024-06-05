Build a docker image to run HashiCorp Vault for the dockerized UH Groupings 
project.

# Preamble

This is purely experimental at this point.

The design goal is to implement a .vault in the developer home directory to 
persistently store the Grouper API password used by the UH Groupings API.

When the developer attempts to run the containerized UH Groupings project 
the vault will supply the password.

# Instructions

## Assumptions
- The HOME environment variable is defined (true by default for linux and macOS)

## Container Setup

Define HOME if it is not defined by default, for now.

Start the container, confirm that it is running.

    docker-compose up -d
    docker ps

## Vault Setup

- **Be sure to save the unseal key and root token.**
- The vault needs to be unsealed upon initialization, after a service restart,
or if it has been manually sealed.
- The root token is not required to add and access secrets. It is used to 
configure the vault, set up policies, enable authentication methods and secret 
engines.
- For development only 1 unseal key is required, rather than the usual 2-3.


    docker exec -it groupings-vault sh
    vault operator init -key-shares=1 -key-threshold=1
    vault operator unseal <Unseal_Key>

## Secrets Management

    vault kv put secret/uh-groupings/config GROUPER_API_PWD="s3cr3tpassword"

## Example Use of Secret During an Application Image Deployment

### Dockerfile

    FROM rockylinux/rockylinux:latest
    
    # Install curl and jq
    RUN dnf -y update && \
        dnf -y install curl jq && \
        dnf clean all
    
    # Set the working directory to /app
    WORKDIR /app
    
    # Copy the Bash script into the container
    COPY fetch_secret.sh /app/
    
    # Make the script executable
    RUN chmod +x /app/fetch_secret.sh
    
    # Define environment variable for Vault address and token
    ENV VAULT_ADDR="http://0.0.0.0:8200"
    ENV VAULT_TOKEN="your-vault-token"
    
    # Command to execute the Bash script
    CMD ["/app/fetch_secret.sh"]

### fetch_secret.sh

    #!/bin/bash
    
    # Fetch the secret
    response=$(curl --header "X-Vault-Token: $VAULT_TOKEN" \
        --request GET \
        $VAULT_ADDR/v1/secret/data/myapp/config)
    
    # Parse the secret
    api_password=$(echo $response | jq -r .data.data.GROUPER_API_PWD)
    
    echo "API Password: $api_password"

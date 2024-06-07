# Table of Contents

<!-- TOC -->
* [Preamble](#preamble)
* [Instructions](#instructions)
  * [Linux/macOS](#linuxmacos)
  * [Windows](#windows)
  * [Vault Setup](#vault-setup)
  * [Access Vault via the Web Interface](#access-vault-via-the-web-interface)
    * [Set up the Grouper API password secret](#set-up-the-grouper-api-password-secret)
    * [Set up the access policy for the groupings deployment](#set-up-the-access-policy-for-the-groupings-deployment)
    * [Create the password access token for the groupings deployment](#create-the-password-access-token-for-the-groupings-deployment)
* [Examples](#examples)
  * [Dockerfile](#dockerfile)
  * [fetch_secret.sh](#fetch_secretsh)
* [Troubleshooting](#troubleshooting)
  * [vault Error Head](#vault-error-head)
<!-- TOC -->

# Overview

**_This is purely experimental at this point._**

Deploy a docker container on a development localhost environment to run 
HashiCorp Vault to contain secrets for a containerized UH Groupings development
instance.

Implement a vault under the developer home directory to persistently store the 
Grouper API password used by the UH Groupings API. When the developer attempts 
to run the containerized UH Groupings project the vault will supply the 
password.



# Installation

Recommendation: download the project from GitHub to a temporary working 
directory for easy cleanup.

## Linux/macOS

Download the project.

    mkdir gitclone
    cd gitclone
    git clone https://github.com/uhawaii-system-its-ti-iam/hashicorp-vault-docker-image.git

Prep env, start container.

    cd hashicorp-vault-docker-image
    chmod +x init-localhost.sh
    ./init-localhost.sh

## Windows

Download the project.

    mkdir gitclone
    cd gitclone
    git clone https://github.com/uhawaii-system-its-ti-iam/hashicorp-vault-docker-image.git

Prep env, start container.

    cd hashicorp-vault-docker-image
    ./init-localhost.bat

## Vault Setup

- **Be sure to save the unseal key and root token.**
- The vault needs to be unsealed upon initialization, after a service restart,
or if it has been manually sealed.
- The root token is not required to add and access secrets. It is used to 
configure the vault, set up policies, enable authentication methods and secret 
engines. **However, it is needed to use the UI to manage the vault.**
- For development only 1 unseal key is required, rather than the usual 2-3.


    docker exec -it groupings-vault sh
    vault operator init -key-shares=1 -key-threshold=1
    vault operator unseal <Unseal_Key>

## Access Vault via the Web Interface

Use the web UI to manage secrets, policies, etc.

- Navigate to http://localhost:8200
- Use the root token to log in.

### Set up the Grouper API password secret

### Set up the access policy for the groupings deployment

### Create the password access token for the groupings deployment

# Examples

## Dockerfile

Use a Secret During an Application Image Deployment

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

## fetch_secret.sh

    #!/bin/bash
    
    # Fetch the secret
    response=$(curl --header "X-Vault-Token: $VAULT_TOKEN" \
        --request GET \
        $VAULT_ADDR/v1/secret/data/myapp/config)
    
    # Parse the secret
    api_password=$(echo $response | jq -r .data.data.GROUPER_API_PWD)
    
    echo "API Password: $api_password"

# Troubleshooting

## vault Error Head

vault Error Head "https://registry-1.docker.io/v2/library/vault/manifests/latest": unauth...

You must have a dockerhub access token.
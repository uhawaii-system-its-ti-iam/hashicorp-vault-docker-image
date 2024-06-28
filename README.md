# Table of Contents

<!-- TOC -->
* [Overview](#overview)
* [Installation](#installation)
  * [Linux/macOS](#linuxmacos)
  * [Windows](#windows)
  * [Vault Setup and Startup](#vault-setup-and-startup)
  * [Access Vault via the Web Interface](#access-vault-via-the-web-interface)
    * [Set up the Grouper API password secret](#set-up-the-grouper-api-password-secret)
    * [Set up the access policy for the groupings deployment](#set-up-the-access-policy-for-the-groupings-deployment)
    * [Create the password access token for the groupings deployment](#create-the-password-access-token-for-the-groupings-deployment)
* [Examples](#examples)
  * [Dockerfile](#dockerfile)
  * [fetch_secret.sh](#fetch_secretsh)
* [Troubleshooting](#troubleshooting)
  * [version is obsolete](#version-is-obsolete)
  * [vault Error Head](#vault-error-head)
<!-- TOC -->

# Overview

**_This project is purely experimental at this point._**

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

## Linux/macOS/Windows

Download the project.

    mkdir gitclone
    cd gitclone
    git clone https://github.com/uhawaii-system-its-ti-iam/hashicorp-vault-docker-image.git

Prep env, start container.

  For Windows use the .bat file instead.

    cd hashicorp-vault-docker-image
    chmod +x init-build.sh
    ./init-build.sh

## Vault Setup and Startup

- For development only 1 unseal key is required, rather than the usual 2-3.
- The vault needs to be unsealed upon initialization, after a service restart,
or if it has been manually sealed.
- The vault must be unsealed before the UI will be operational.
- The root token is not required to add and access secrets. It is used to 
configure the vault, set up policies, enable authentication methods and secret 
engines.

The following can be executed from within docker desktop. 
- navigate to the "containers" menu
- select the stack "hashicorp-vault-docker-image"
- expand it in order to select the image "groupings-vault". 
- the "Logs" menu is the default, select the "Exec" menu to access the 
container's command prompt enter the following:


    vault operator init -key-shares=1 -key-threshold=1
    vault operator unseal <Unseal_Key>

Be sure to save the unseal key and root token for later use.

Ensure that the key-value secrets engine is installed:

    vault login
    vault secrets enable -path=secret kv-v2
    vault secrets list 

## Store the Grouper API Password

Replace the sample password with the actual password.

    vault kv put secret/uhgroupings grouperClient.webService.password=samplepwd
    vault kv get -format=json secret/uhgroupings

## Access Vault via the Web Interface

Use the web UI to manage secrets, policies, etc.

- Navigate to http://localhost:8200
- Use the root token to log in.

### Set up the Grouper API password secret

more info needed here

### Set up the access policy for the groupings deployment

more info needed here

### Create the password access token for the groupings deployment

more info needed here

# Troubleshooting

## version is obsolete

    WARN[0000] .../hashicorp-vault-docker-image/docker-compose.yml: `version` is obsolete

Docker Compose v2 warns that the version setting is obsolete. Remove it from the docker-compose file.

## vault Error Head

    vault Error Head "https://registry-1.docker.io/v2/library/vault/manifests/latest": unauth...

You must have a dockerhub access token in order to download docker images from Docker Hub.

## connection refused

    operator init -key-shares=1 -key-threshold=1
    Get "http://127.0.0.1:8200/v1/sys/seal-status": dial tcp 127.0.0.1:8200: connect: connection refuse

## vault needs to be reinitialized

This requires starting over.

1) Stop the container
2) Delete the vault (see below)
3) Start the container
4) Initialize the vault


    rm -rf ${HOME}/.vault/uhgroupings/data/*

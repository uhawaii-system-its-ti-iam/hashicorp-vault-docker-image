#!/bin/sh

# init-localhost.sh - initialize for running vault.

# Check if HOME environment variable is not set.
if [ -z "${HOME}" ]; then
  echo "Error: the HOME environment variable is not set."
  exit 1
fi

# Create the necessary directories for Vault data and configuration.
mkdir -v ${HOME}/.vault/uhgroupings/data
mkdir -v ${HOME}/.vault/uhgroupings/config

# Copy the Vault configuration file to the appropriate directory.
cp -v vault-config.hcl ${HOME}/.vault/uhgroupings/config

# Start the Vault container using Docker Compose.
docker-compose up -d

# Check if Docker Compose started successfully.
if [ $? -eq 0 ]; then
  echo "Success: the vault container started successfully."
else
  echo "Error: failed to start the Vault container."
  exit 1
fi

exit 0

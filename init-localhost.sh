#!/bin/sh

# init-localhost.sh - initialize for running vault

mkdir -v ${HOME}/.vault/uhgroupings/data
mkdir -v ${HOME}/.vault/uhgroupings/config

cp -v vault-config.hcl ${HOME}/.vault/uhgroupings/config

exit 0

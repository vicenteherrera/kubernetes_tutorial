#!/bin/bash
export TF_VAR_client_id=$(az keyvault secret show --name "spId" --vault-name "SysTest-Vault" --query value -o tsv)
export TF_VAR_client_secret=$(az keyvault secret show --name "spSecret" --vault-name "SysTest-Vault" --query value -o tsv)
export RM_ACCESS_KEY=$(az keyvault secret show --name "tstateAccessKey" --vault-name "SysTest-Vault" --query value -o tsv)


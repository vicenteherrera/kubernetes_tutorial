#!/bin/bash
echo "Reading SP client_id"
export TF_VAR_client_id=$(az keyvault secret show --name "spId" --vault-name "SysTest-Vault" --query value -o tsv)
echo "Reading SP client_secret"
export TF_VAR_client_secret=$(az keyvault secret show --name "spSecret" --vault-name "SysTest-Vault" --query value -o tsv)
echo "Reading Backend access_key"
export ARM_ACCESS_KEY=$(az keyvault secret show --name "tstateAccessKey" --vault-name "SysTest-Vault" --query value -o tsv)

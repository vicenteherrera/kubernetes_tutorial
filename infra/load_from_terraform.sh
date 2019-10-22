#!/bin/bash
dir_original=$(pwd)
dir_script=$(dirname $(which $BASH_SOURCE))
cd $dir_script

#export ACR_URI="systestacr.azurecr.io"
#export SKAFFOLD_DEFAULT_REPO="systestacr.azurecr.io"

echo "Reading ACR URI"
export ACR_URI="$(terraform output acr_uri)"
export SKAFFOLD_DEFAULT_REPO=$ACR_URI

echo "Login with Docker to your ACR"
docker login $ACR_URI -u $(terraform output acr_user) -p $(terraform output acr_password)

echo "Getting Kubectl configuration"
az aks get-credentials --resource-group SysTest-k8s-resources --name SysTest-k8s --overwrite

cd $dir_original
# Azure Hipster Shop: AKS Microservices Demo

## 2. Initial Azure resources setup

This procedure should be done only once, even if you delete the cluster and destroy the infrastructure resources.

### Create Storage for Terraform to store plan

We will use an storage volume in Azure to store the infrastructure state created with Terraform later. To do this, execute the following script and it will create on _westeurope_ location a Resource Group called "tstate", and inside it, an storage with "tstatesystest" name.

For more information, see: https://docs.microsoft.com/en-us/azure/terraform/terraform-backend

```
#!/bin/bash

RESOURCE_GROUP_NAME=tstate
STORAGE_ACCOUNT_NAME=tstatesystest
CONTAINER_NAME=tstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location westeurope

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
```

At the end of the execution, the result environment variables will be shown.

### Create a Key Vault and store secrets

We will need several secret values stored, but we don't want them to be stored on a file that can be stolen or uploaded to an unsafe place. To store them securely, we will create an Azure Key Vault resource.

To create a Key Vault resource named "SysTest-Vault" in resoure group "tstate" on _westeurope_ location, use:

```
az keyvault create --name "SysTest-Vault" --resource-group "tstate" --location westeurope
```

To store the access key of the volume in the Key Vault:

```
az keyvault secret set --vault-name "SysTest-Vault" --name "tstateAccessKey" --value $ACCOUNT_KEY
```

Any time later you need to retrieve this value, you cand do so after having logged in with Azure CLI, using:

```
az keyvault secret show --name "tstateAccessKey" --vault-name "SysTest-Vault" --query value -o tsv
```

_Optional_: You can also reference this secret on Azure using its unique URI:  
https://SysTest-Vault.vault.azure.net/secrets/tstateAccessKey 


### Create a Service Principal with the command line

A Service Principal is like a new user that we create to grant permissions to only do what we need it to do. That way we are not using our user with owner role. 

AKS needs a service principal to be able to create virtual machines for the Kubernetes cluster infrastructure.

To create a new Service Principal named "ServPrincipalAKS", use the following command, replacing 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX' with your account id shown when you log in with `az login`.

```
$ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" --name ServPrincipalAKS

Creating a role assignment under the scope of "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  Retrying role assignment creation: 1/36
  Retrying role assignment creation: 2/36
{
  "appId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "displayName": "azure-cli-XXXX-XX-XX-XX-XX-XX",
  "name": "http://azure-cli-XXXX-XX-XX-XX-XX-XX",
  "password": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "tenant": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
}
```

Optional: Without additional steps, the password (secret) can't be retrieved later, ([but you could reset it here](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#reset-credentials) ).

Optional: To retrieve the rest of the data from existing service principals created from the command line, use:

```
az ad sp list --display-name ServPrincipalAKS
```

If you didn't use a name for the service principal, its name will have the prefix "azure-cli-", and you can look for it with:

```
az ad sp list --display-name azure-cli-
```

**Alternative: Create a Service Principal using Azure Portal** 

If you prefer to use the web interface, follow [these instructions](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal). Don't forget to [assign the application](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#assign-the-application-to-a-role) a [contributor role](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)

### Save Service Principal id and secret to Key Vault

Take note of the appId (the id) and the password (the secret) for the service principal just created. We will store them in the Key Vault. 

```
az keyvault secret set --vault-name "SysTest-Vault" --name "spId" --value "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
az keyvault secret set --vault-name "SysTest-Vault" --name "spSecret" --value "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
```

Now, when we want to retrieve them and the storage access key to environment variables that Terraform can use, without having the written down in any file, we use:

```
TF_VAR_client_id=$(az keyvault secret show --name "spId" --vault-name "SysTest-Vault" --query value -o tsv)
TF_VAR_client_secret=$(az keyvault secret show --name "spSecret" --vault-name "SysTest-Vault" --query value -o tsv)
ARM_ACCESS_KEY=$(az keyvault secret show --name "tstateAccessKey" --vault-name "SysTest-Vault" --query value -o tsv)
```

Those special variable names are expected by Terraform for those parameters. Remember, for those commands to work, we must have logged in with the Azure CLI first.

### Alternative: Use the Service Principal to provision infrastructure instead of Azure CLI

You could use the identity of the Service Principal to provision the whole infrastructure with Terraforn.
If you set up the following environment variables, Terraform will use that identity instead of the Azure CLI logged in user.

```
ARM_CLIENT_ID=$(az keyvault secret show --name "spId" --vault-name "SysTest-Vault" --query value -o tsv)
ARM_CLIENT_SECRET=$(az keyvault secret show --name "spSecret" --vault-name "SysTest-Vault" --query value -o tsv)
ARM_TENANT_ID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX # : Obtain it from the account info on login
ARM_SUBSCRIPTION_ID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX # Obtain it from the account info on login
```


---
[Next step: 3. Provision infrastructure with Terraform](../docs/03_infra_terraform.md)  
[Previous step: 1. Prerequisites](../docs/01_prerequisites.md)  


# Azure Hipster Shop: AKS Microservices Demo

## 2. Initial Azure setup

This procedure should be done only once, even if you delete the cluster and destroy the infrastructure resources.

### Create and Azure account

Browse the Azure portal website and create a new account:

 * http://azure.microsoft.com/

### Configure AZ Cli

Use `az login` to log into your Azure account. A new browser window will open where you can finish the login procedure before returning to the terminal.
If using a remote terminal or an environment without a browser, an special code and URL will be shown to open in another computer's browser to finish the login procedure.

```
$ az login

Note, we have launched a browser for you to login. For old experience with device code, use "az login --use-device-code"
You have logged in. Now let us find all the subscriptions to which you have access...
[
  {
    "cloudName": "AzureCloud",
    "id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "isDefault": true,
    "name": "Your-subscription-name",
    "state": "Enabled",
    "tenantId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "user": {
      "name": "your.email@your.domain.example.com",
      "type": "user"
    }
  }
]
```

Now you'r `az` command line instructions will use your account credentials.

Optional: You can check any time what account you are logged in and this information with:

```
$ az account show
```

You may need to register the use of the following providers with your Azure account to create the kind of resources we are going to use.

```
az provider register -n Microsoft.Network
az provider register -n Microsoft.Storage
az provider register -n Microsoft.Compute
az provider register -n Microsoft.ContainerService
```

### Create Storage for Terraform to store plan

Execute the following script to create a Resource Group called "tstate", and inside it, an storage with random name.

For more information, see: https://docs.microsoft.com/en-us/azure/terraform/terraform-backend

```
#!/bin/bash

RESOURCE_GROUP_NAME=tstate
STORAGE_ACCOUNT_NAME=tstatesystest
CONTAINER_NAME=tstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

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


Create a Key Vault in resoure group "tstate"

```
az keyvault create --name "SysTest-Vault" --resource-group "tstate" --location eastus
```

Store access key to the volume in the Key Vault:

```
az keyvault secret set --vault-name "SysTest-Vault" --name "tstateAccessKey" --value $ACCOUNT_KEY
```

Any time later you need to retrieve this value, you cand do so after having logged in with Azure CLI, using:

```
az keyvault secret show --name "tstateAccessKey" --vault-name "SysTest-Vault" --query value -o tsv
```

Optional: You can also reference this secret on Azure using its unique URI:  
https://SysTest-Vault.vault.azure.net/secrets/tstateAccessKey 


### Create a Service Principal with the command line

A Service Principal is like a new user that we create to grant permissions to only do what we need it to do. That way we are not using our user with owner role. 

AKS needs a service principal to be able to create virtual machines for the Kubernetes cluster infrastructure.

To create a new Service Principal named ServPrincipalAKS, use the following command, replacing 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX' with your account id shown in the previous command's outputs.

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

//TODO:

* Create Service Principal with TF  https://medium.com/@kari.marttila/creating-azure-kubernetes-service-aks-the-right-way-9b18c665a6fa
* Create monitoring and logging
* Stablish variable types as string
* Store Terraform state on Azure Store
* Pipeline for CD/CI
* Param different environments instead of "example"


---
[Next step: 3. Provision infrastructure with Terraform](../doc/03_infra_terraform.md)  
[Previous step: 1. Installing prerequisites](../doc/01_prerequisites.md)  


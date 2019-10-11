# Azure Hipster Shop: AKS Microservices Demo

This project is an extension of the project "Hipster Shop: Cloud-Native Microservices Demo Application" from Google, available here: https://github.com/GoogleCloudPlatform/microservices-demo

The main focus here is to be able to deploy that demo project to Azure Kubernetes Service using best practices.

## Getting started

We will assume you work with a *bash* environment. 

If you are using Windows, most of the explanations here could be used in cmd.exe, but you will achieve full compatibily by using [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

### Install prerequisites

You will need to install the following tools:

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* Docker: [win]() [mac]() [linux](https://docs.docker.com/install/linux/docker-ce/ubuntu/) 
* [Terraform](https://www.terraform.io/downloads.html)
* [Skaffold](https://skaffold.dev/docs/getting-started/#installing-skaffold) 
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) 

### Configure AZ Cli

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

You can check any time what account you are logged in and this information with:

```
$ az account show
```

### Create a Service Principal with the command line

```
$ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/
XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"

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

(( --name ServicePrincipalName ))

Use the value for 'id' field.

The password (client secret) can't be retrieved later. If you forget the credentials, you will have to [reset them](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#reset-credentials).

To retrieve the rest of the data from existing service principals created from the command line, use:

```
az ad sp list --display-name azure-cli-
```

### Create a Service Principal using Azure Portal



If you prefer to use the web interface, follow [these instructions](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal). Don't forget to [assign the application](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#assign-the-application-to-a-role) a [contributor role](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)

### Store security parameters in environment variables

* ARM_CLIENT_ID: Service principal id
* ARM_CLIENT_SECRET: Service principal password
* ARM_TENANT_ID: Obtain it from the account info on login
* ARM_SUBSCRIPTION_ID = Obtain it from the account info on login

```
set -gx ARM_CLIENT_ID "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
set -gx ARM_CLIENT_SECRET "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
set -gx ARM_TENANT_ID "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
set -gx ARM_SUBSCRIPTION_ID "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
```


## Deploy infrastructure with Terraform

Change to the `infra` directory and initialize Terraform's Azure driver:

```
$ terraform init
```

Test the execution plan:

```
$ terraform plan
```

## Check the Kubernetes cluster

```
$ az aks get-credentials --resource-group agonesRG --name test-cluster
$ kubectl get nodes
```
## Tear down the infrastructure

Don't forget to tear down the Kubernetes cluster when you have finished experimenting with it. As the load test tool will start to generate simulated traffic inmediatly, it will lead to expensive charges if left running.

```
$ terraform destroy
```
# Azure Hipster Shop: AKS Microservices Demo

This project is an extension of the project "Hipster Shop: Cloud-Native Microservices Demo Application" from Google, available here: https://github.com/GoogleCloudPlatform/microservices-demo

The main focus here is to be able to deploy that demo project to Azure Kubernetes Service using best practices.

## Limitations

The Stackdriver log monitor is specific to Google Cloud, the driver will try to connect several times and then give up.
See microservices-demo/docs/development-principles.md

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

TODO:

* Name service principal
* Remove service principal key from main.tf
* Store secrets in key vault

## Deploy infrastructure with Terraform

Change to the `infra` directory and initialize Terraform's Azure driver:

```
$ terraform init
```

Test the execution plan:

```
$ terraform plan -var client_id=$ARM_CLIENT_ID -var client_secret=$ARM_CLIENT_SECRET
```

Run the execution plan using credetials for the service principal:

```
$ terraform apply -var client_id=$ARM_CLIENT_ID -var client_secret=$ARM_CLIENT_SECRET
```

## Get Kubectl credentials

Alternative 1. Using Azure-cli:
```
$ az aks get-credentials --resource-group SysTest-k8s-resources --name SysTest-k8s
```

Alternative 2. Using Terraform output variables:
```
$ export KUBECONFIG="$(terraform output kube_config)"
```


To later check which context you are connected to with kubectl:

```
kubectl config current-context
```

If you what to list all other contexts:

```
kubectl context view
```
## Login with Docker to Azure Cointer Registry

```
$  docker login $(terraform output acr_uri) -u $(terraform output acr_user) -p $(terraform output acr_password)

WARNING! Using --password via the CLI is insecure. Use --password-stdin.
WARNING! Your password will be stored unencrypted in /home/mord/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

We will also store the ACR URI, so it is easier to reference outside terraform infrastructure directory:
```
$ export ACR_URI="$(terraform output acr_uri)" && echo $ACR_URI
```

## Set up the kubernetes cluster with Skaffold

```
$ cd ..
$ cd microservices-demo
$ skaffold run --default-repo $ACR_URI --tail

Generating tags...
 - testacr22.azurecr.io/emailservice -> testacr22.azurecr.io/emailservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/productcatalogservice -> testacr22.azurecr.io/productcatalogservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/recommendationservice -> testacr22.azurecr.io/recommendationservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/shippingservice -> testacr22.azurecr.io/shippingservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/checkoutservice -> testacr22.azurecr.io/checkoutservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/paymentservice -> testacr22.azurecr.io/paymentservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/currencyservice -> testacr22.azurecr.io/currencyservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/cartservice -> testacr22.azurecr.io/cartservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/frontend -> testacr22.azurecr.io/frontend:v0.1.2-2-g2177813
 - testacr22.azurecr.io/loadgenerator -> testacr22.azurecr.io/loadgenerator:v0.1.2-2-g2177813
 - testacr22.azurecr.io/adservice -> testacr22.azurecr.io/adservice:v0.1.2-2-g2177813
Tags generated in 16.110141ms
Checking cache...
 - testacr22.azurecr.io/emailservice: Found. Pushing
The push refers to repository [testacr22.azurecr.io/emailservice]
```

## Check the health of the cluster

```
$ kubectl get nodes
```

Check all pods

```
$ kubectl get pods --all-namespaces
```

## Tear down the cluster and infrastructure

Don't forget to tear down the Kubernetes cluster when you have finished experimenting with it. As the load test tool will start to generate simulated traffic inmediatly, it will lead to expensive charges if left running.

```
$ skaffold delete
```

To also delete the Azure infrastructure resources, use:

```
$ cd ..
$ cd infra
$ terraform destroy
```

## Troubleshooting

### Not available Microsoft.Network

### One or more node with status 'CrashLoopBackOff'

```
$ kubectl get pods
$ kubectl describe pod pod-crashloopbackoff-7f7c556bf5-9vc89
$ kubectl logs pod-crashloopbackoff-7f7c556bf5-9vc89 im-crashing
$ kubectl describe pod pod-crashloopbackoff-liveness-probe-7564df8646-v96tq
```
See https://sysdig.com/blog/debug-kubernetes-crashloopbackoff/
https://managedkube.com/kubernetes/pod/failure/crashloopbackoff/k8sbot/troubleshooting/2019/02/12/pod-failure-crashloopbackoff.html

### failed to initialize stackdriver exporter: stackdriver: 

```
failed to initialize stackdriver exporter: stackdriver:  google: could not find default credentials. See https://developers.google.com/accounts/docs/application-default-credentials for more information
```

Stackdriver only exist in the Google Cloud Environment

### Node size

Node must have at least 6 Gb RAM and 32 Gb hard disk. 1 Node for testing, 3 for "production".

### Service principal should have permission

### RBCA not enabled
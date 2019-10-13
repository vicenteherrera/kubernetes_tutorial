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


### Azure CLI Authorization Profile was not found

You have done `az login` and `az account show` works.

But when you try `terraform plan`, you get an error like this:

```
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

Error: Error running plan: 3 error(s) occurred:

* module.resource-group.provider.azurerm: Error building AzureRM Client: Azure CLI Authorization Profile was not found. Please ensure the Azure CLI is installed and then log-in with `az login`.
* module.acr.provider.azurerm: Error building AzureRM Client: Azure CLI Authorization Profile was not found. Please ensure the Azure CLI is installed and then log-in with `az login`.
* module.aks.provider.azurerm: Error building AzureRM Client: Azure CLI Authorization Profile was not found. Please ensure the Azure CLI is installed and then log-in with `az login`.
```

*Non working solutions*



*Solution*

Update your Terraform client from the official web page (at least version 12.10).

If after that you still experience problems, try them resetting your `az` token with one of these commands:
 * `az logout && az login`
 * `az account get-access-token`
 * `rm -rf $HOME/.azure && az login`

Another alternative is to use the same credentials of the created Service Principal to issue Terraform commands, by setting these variables:

```
ARM_CLIENT_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
ARM_CLIENT_SECRET="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
ARM_TENANT_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
ARM_SUBSCRIPTION_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
```

*Related references*
 * https://www.terraform.io/docs/providers/azurerm/index.html
 * https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html


### Unknown token: 19:25 IDENT module.resource-group.name

``` 
$ terraform init
There are some problems with the configuration, described below.

The Terraform configuration must be valid before initialization so that
Terraform can determine which modules and providers need to be installed.

Error: Error parsing /home/mord/code/amd/infra/main.tf: At 19:25: Unknown token: 19:25 IDENT module.resource-group.name
```

Update your terraform binary to latest version (at least v0.12.10). Make sure you go to the official page referenced in this documentation for the latest one.
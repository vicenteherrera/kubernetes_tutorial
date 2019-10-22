# Azure Hipster Shop: AKS Microservices Demo

## 3. Provision infrastructure with Terraform

Change to the `infra` directory and initialize Terraform's Azure driver:

You can edit the  `terraform.tfvars` to select a different availability zone, or name prefix for resources. But the prefix must contain only alphabetical characters, because it is used for the name of the Azure Container Registry, and that only allows this kind of characters (no numbers, dashes or undescores).

```
$ cd infra
$ terraform init -backend-config=backend.tfconfig
```

Test the execution plan:

```
$ terraform plan
```

The change that should be performed will be shown.

To run the execution plan use:

```
$ terraform apply
```

You will be shown the plan again, and asked for confirmation to continue. The provisioning process will last more than 10 minutes. At the beginnig of this process, the plan will be saved on the Azure storage created previously, and the file marked as 'locked', so anybody else using the same plan will be prevented to do changes to infrastructure until you finish.

At the end you will be shown an output like this:

```
...
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

Outputs:

acr_password = <sensitive>
acr_uri = systestacr.azurecr.io
acr_user = SysTestAcr
client_certificate = <sensitive>
client_key = <sensitive>
cluster_ca_certificate = <sensitive>
host = https://systest-k8s-XXXX.hcp.westeurope.azmk8s.io:443
id = /subscriptions/XXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourcegroups/SysTest-k8s-resources/providers/Microsoft.ContainerService/managedClusters/SysTest-k8s
kube_config = <sensitive>
resource_group_name = SysTest-k8s-resources
```

//TODO:


* Stablish variable types as string
* "Example"
* Tags

### Improvements

You could create the service principal using also Terraform. [example](https://medium.com/@kari.marttila/creating-azure-kubernetes-service-aks-the-right-way-9b18c665a6fa)

You could also create a Log Analytics resource for the cluster. [example](https://docs.microsoft.com/en-us/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks)

Use __workspaces__ to define different paramenters for a production and development kubernetes environment ([more info](https://www.terraform.io/docs/state/workspaces.html) )

---
[Next step: 4. Get credentials Kubectl and ACR](../docs/04_get_credentials.md)  
[Previous step: 2. Initial Azure resources setup](../docs/02_setup_az_sp.md)


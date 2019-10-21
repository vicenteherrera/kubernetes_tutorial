# Azure Hipster Shop: AKS Microservices Demo

## 3. Provision infrastructure with Terraform

Change to the `infra` directory and initialize Terraform's Azure driver:

You can edit the  `terraform.tfvars` to select a different availability zone, or name prefix for resources. But the prefix must contain only alphabetical characters, because it is used for the name of the Azure Container Registry, and that only allows this kind of characters (no numbers, dashes or undescores).

```
$ cd infra
$ terraform init
```

Test the execution plan:

```
$ terraform plan -out=tfplan
```

We store the generated plan, so if once deployed we change the content of the Terraform files, we still know how to destroy what has been created.

Run the execution plan using credetials for the service principal:

```
$ terraform plan tfplan

terraform apply tfplan
module.resource_group.azurerm_resource_group.example: Creating...
module.resource_group.azurerm_resource_group.example: Creation complete after 1s [id=/subscriptions/XXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/SysTest-k8s-resources]
module.public_ip.azurerm_public_ip.example: Creating...
module.acr.azurerm_container_registry.example: Creating...
module.aks.azurerm_kubernetes_cluster.example: Creating...
module.public_ip.azurerm_public_ip.example: Creation complete after 4s [id=/subscriptions/XXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/SysTest-k8s-resources/providers/Microsoft.Network/publicIPAddresses/SysTest-PublicIPForLB]
module.load_balancer.azurerm_lb.example: Creating...
module.acr.azurerm_container_registry.example: Creation complete after 5s [id=/subscriptions/XXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/SysTest-k8s-resources/providers/Microsoft.ContainerRegistry/registries/SysTestAcr]
module.load_balancer.azurerm_lb.example: Creation complete after 1s [id=/subscriptions/XXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/SysTest-k8s-resources/providers/Microsoft.Network/loadBalancers/SysTest-LoadBalancer]
module.aks.azurerm_kubernetes_cluster.example: Still creating... [10s elapsed]
module.aks.azurerm_kubernetes_cluster.example: Still creating... [20s elapsed]
...
```

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
host = https://systest-k8s-70eecd11.hcp.westeurope.azmk8s.io:443
id = /subscriptions/XXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourcegroups/SysTest-k8s-resources/providers/Microsoft.ContainerService/managedClusters/SysTest-k8s
kube_config = <sensitive>
resource_group_name = SysTest-k8s-resources
```

---
[Next step: 4. Get credentials Kubectl and ACR](../doc/04_get_credentials.md)  
[Previous step: 2. Initial Azure setup](../doc/02_setup_az_sp.md)


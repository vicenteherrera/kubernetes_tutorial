# Azure Hipster Shop: AKS Microservices Demo

## 7. Tear down the cluster and infrastructure

Don't forget to tear down the Kubernetes cluster when you have finished experimenting with it. As the load test tool will start to generate simulated traffic inmediatly, it will lead to expensive charges if left running.

```
$ skaffold delete
```

To also delete the Azure infrastructure resources, use:

```
$ cd ..
$ cd infra
$ terraform destroy -var client_id=$ARM_CLIENT_ID -var client_secret=$ARM_CLIENT_SECRET
```

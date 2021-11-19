---
layout: default
title: Kubernetes tutorial
description: Azure Kubernetes Service, Terraform, Helm, Prometheus, Grafana, Skaffold
breadcrumb1: 7. Tear down the cluster and infrastructure
---
[<< Back to index](../){:class="solid-btn text-center"}

# Kubernetes tutorial


## 7. Tear down the cluster and infrastructure

### Delete microservices resources

Don't forget to tear down the Kubernetes cluster when you have finished experimenting with it. As the load test tool will start to generate simulated traffic immediately, it will lead to expensive charges if left running.

From the `microservices-demo` folder, run:

```console
$ cd microservices-demo
$ skaffold delete
```

### Delete Prometheus and Grafana resources

To delete the prometheus-operator resources, use

```bash
helm delete --purge prometheus
```

`prometheus-operator` defines some custom resource definitions (CRDs), that have to be deleted manually:

```bash
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
```

### Destroy infrastructure elements

To also destroy the Azure infrastructure elements, from the `infra` folder use:

```console
$ cd ..
$ cd infra
$ terraform destroy
```

---
[Next step: Appendix Troubleshooting >>](../docs/99_troubleshooting.md){:class="solid-btn text-center"}    

[<< Previous step: 6. Create cluster with Skaffold](../docs/06_helm.md){:class="solid-btn text-center"}  

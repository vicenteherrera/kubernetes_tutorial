# Azure Hipster Shop: AKS Microservices Demo

## 7. Tear down the cluster and infrastructure

### Delete Prometheus and Grafana resources

To delete the prometheus-operator resources, use

```
helm delete --purge prometheus
```

prometheus-operator defines some custom resource definitions (CRDs), that have to be deleted manually:

```
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
```

### Delete microservices resources

Don't forget to tear down the Kubernetes cluster when you have finished experimenting with it. As the load test tool will start to generate simulated traffic immediately, it will lead to expensive charges if left running.

From the `microservices-demo` folder, run:
```
$ cd microservices-demo
$ skaffold delete
```

### Destroy infrastructure elements

To also destroy the Azure infrastructure elements, from the `infra` folder use:

```
$ cd ..
$ cd infra
$ terraform destroy
```

---
[Next step: Appendix Troubleshooting](../docs/99_troubleshooting.md)  

[Previous step: 6. Create cluster with Skaffold](../docs/06_helm.md)

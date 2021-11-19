---
layout: default
title: Kubernetes tutorial
description: Azure Kubernetes Service, Terraform, Helm, Prometheus, Grafana, Skaffold
breadcrumb1: "Appendix: Troubleshooting"
---
[<< Back to index](../){:class="solid-btn text-center"}

# Kubernetes tutorial


## Appendix: Troubleshooting

### One or more nodes with status 'CrashLoopBackOff'

```bash
$ kubectl get pods
$ kubectl describe pod pod-crashloopbackoff-7f7c556bf5-9vc89
$ kubectl logs pod-crashloopbackoff-7f7c556bf5-9vc89 im-crashing
$ kubectl describe pod pod-crashloopbackoff-liveness-probe-7564df8646-v96tq
```

Try looking for more information at:

 * https://sysdig.com/blog/debug-kubernetes-crashloopbackoff/
 * https://managedkube.com/kubernetes/pod/failure/crashloopbackoff/k8sbot/troubleshooting/2019/02/12/pod-failure-crashloopbackoff.html

### failed to initialize stackdriver exporter: stackdriver: 

```console
failed to initialize stackdriver exporter: stackdriver:  google: could not find default credentials. See https://developers.google.com/accounts/docs/application-default-credentials for more information
```

*Solution*: Stackdriver only exist in the Google Cloud Environment, you don't need to do anything.

### Node size

Node must have at least 6 Gb RAM and 32 Gb hard disk. 1 Node for testing, 3 for "production".

### Azure CLI Authorization Profile was not found

You have done `az login` and `az account show` works.

But when you try `terraform plan`, you get an error like this:

```console
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

*Solution*

Update your Terraform client from the official web page (at least version 12.10).

If after that you still experience problems, try them resetting your `az` token with one of these commands:
 * `az logout && az login`
 * `az account get-access-token`
 * `rm -rf $HOME/.azure && az login`

Another alternative is to use the same credentials of the created Service Principal to issue Terraform commands, by setting these variables:

```bash
ARM_CLIENT_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
ARM_CLIENT_SECRET="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
ARM_TENANT_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
ARM_SUBSCRIPTION_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
```

*Related references*
 * https://www.terraform.io/docs/providers/azurerm/index.html
 * https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html


### Unknown token: 19:25 IDENT module.resource_group.name

```console
$ terraform init
There are some problems with the configuration, described below.

The Terraform configuration must be valid before initialization so that
Terraform can determine which modules and providers need to be installed.

Error: Error parsing /home/mord/code/amd/infra/main.tf: At 19:25: Unknown token: 19:25 IDENT module.resource_group.name
```
*Solution*: Update your terraform binary to the latest version (at least v0.12.10). Make sure you go to the official page referenced in this documentation for the latest one.

### Grafana's dashboard shows Error "Bad Gateway", and no data

*Solution*: You need to specify __--set rbac.create=true__ when you install the Helm chart.

```bash
helm install --namespace monitoring --name prometheus stable/prometheus-operator --set rbac.create=true
```

### Trying to proxy Prometheus web console gives error "pod is not running"

Error message: `error: unable to forward port because pod is not running. Current status=Pending`

If you list the pods in the monitoring namespace, the last one is pending:

```console
$ kubectl get pods --namespace monitoring

NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-prometheus-prometheus-oper-alertmanager-0   2/2     Running   0          6m32s
prometheus-grafana-5c9cdb95fd-rr8gk                      2/2     Running   0          7m7s
prometheus-kube-state-metrics-7488ddf754-rbf7w           1/1     Running   0          7m7s
prometheus-prometheus-node-exporter-pf9zn                1/1     Running   0          7m7s
prometheus-prometheus-oper-operator-7c8567584d-f5h4t     2/2     Running   0          7m7s
prometheus-prometheus-prometheus-oper-prometheus-0       0/3     Pending   0          6m22s
```

There is a bug in Helm that prevents it to create the CRD before using them. Try first creating them manually:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/alertmanager.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/prometheus.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/prometheusrule.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/servicemonitor.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/podmonitor.crd.yaml
```

Wait a couple of seconds, then install the chart with:

```bash
helm install --name prometheus stable/prometheus-operator --set prometheusOperator.createCustomResource=false  --set rbac.create=true
```

See [this for more information](https://github.com/helm/charts/tree/master/stable/prometheus-operator#helm-fails-to-create-crds).

---  
[<< Previous step: 7. Terminate and free resources](../docs/98_free_resources.md){:class="solid-btn text-center"}   

[<< Back to index](../){:class="solid-btn text-center"}
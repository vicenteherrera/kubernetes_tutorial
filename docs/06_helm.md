# Azure Hipster Shop: AKS Microservices Demo

## 6. Installing Prometheus and Grafana using Helm

### Installing Helm client

https://helm.sh/docs/using_helm/#installing-helm


Windows
`choco install kubernetes-helm`

MacOs
`brew install kubernetes-helm`

Linux
`sudo snap install helm --classic`

### Installing Tiller, Kubernetes component

https://helm.sh/docs/using_helm/#installing-tiller

```
helm init --history-max 200
```

To check that Tiller pod is up and running use:

```
$kubectl get pods --namespace kube-system
NAME                                    READY   STATUS    RESTARTS   AGE
coredns-696c4d987c-d4ssp                1/1     Running   0          2d9h
coredns-696c4d987c-wmwwj                1/1     Running   0          2d9h
coredns-autoscaler-657d77ffbf-tj7vf     1/1     Running   0          2d9h
kube-proxy-9kxnv                        1/1     Running   0          2d9h
kubernetes-dashboard-66d756f947-jft28   1/1     Running   0          2d9h
metrics-server-58699455bc-wvrjb         1/1     Running   0          2d9h
tiller-deploy-57f498469-prsfg           1/1     Running   0          58s
tunnelfront-6f4cb4755b-wjfvw            1/1     Running   0          2d9h
```

Helm uses a packaging format called charts. A chart is a collection of files that describe a related set of Kubernetes resources. The default location for Helm charts are their Github repository at:
https://github.com/helm/charts.git

You can update the list of charts available using:
```
helm repo up
```

To search for a chart, you can use the search command:
```
helm search stable/prometheus-operator --versions --version=">=6" --col-width=30
```

We are going to install the prometheus-operator Helm chart, with the name __prometheus__ in a namespace named __monitoring__

```
helm install --namespace monitoring --name prometheus stable/prometheus-operator --set rbac.create=true
```

We need to specify the rbac.create=true variable for it to work in Azure.

To check Prometheu's pods in the monitoring namespace use:

```
$ kubectl get pods --namespace monitoring
NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-prometheus-prometheus-oper-alertmanager-0   2/2     Running   0          3m32s
prometheus-grafana-b4fb4d64d-j95b4                       2/2     Running   0          4m2s
prometheus-kube-state-metrics-6fc57fc485-tjb8s           1/1     Running   0          4m2s
prometheus-prometheus-node-exporter-6f6l4                1/1     Running   0          4m2s
prometheus-prometheus-oper-operator-cc4dfd77c-v5wsr      1/1     Running   0          4m2s
prometheus-prometheus-prometheus-oper-prometheus-0       0/3     Pending   0          3m26s
```
### Accessing Prometheus web console

If you want to access Prometheus web console, we have to get its pod's name first:

```
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
```

Then we can open a proxy to it:
```
kubectl --namespace monitoring port-forward $POD_NAME 9090
```

And visit http://localhost:9090

### Accesing Grafana's dashboard and setting it up

Now we are going to set up Grafana.

To know the password for login into Grafana, use:
```
kubectl get secret \
    --namespace monitoring prometheus-grafana \
    -o jsonpath="{.data.admin-password}" \
    | base64 --decode ; echo
```

We need to get Grafana pod name: 

```
export NODE_GRAF=$(kubectl get pods --namespace monitoring -l "app=grafana,release=prometheus" -o jsonpath="{.items[0].metadata.name}")
```

Now we open a proxy to Grafana's  dashboard, and use __admin__ username and the previous password to log in.
```
$ kubectl --namespace monitoring port-forward $POD_NAME 3000
```

And visit http://localhost:3000

We need to define a dashboard for Grafana to represent Prometheus metrics. Click import, load dashboard definition id 1860, and select Prometheus as the data source.

You can browse aditional Grafana dashboard definitions at:
https://grafana.com/dashboards

https://grafana.com/grafana/dashboards/1860

### Delete Prometheus and Grafana resources

helm delete --purge prometheus

helm del --purge prometheus

kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com

### References

https://medium.com/@chris_linguine/how-to-monitor-your-kubernetes-cluster-with-prometheus-and-grafana-2d5704187fc8

https://github.com/helm/charts/tree/master/stable/prometheus-operator

https://medium.com/faun/trying-prometheus-operator-with-helm-minikube-b617a2dccfa3

https://sysdig.com/blog/kubernetes-monitoring-prometheus-operator-part3/

https://www.alibabacloud.com/blog/kubernetes-cluster-monitoring-using-prometheus_594722

https://sysdig.com/blog/prometheus-metrics/

https://devopscube.com/setup-prometheus-monitoring-on-kubernetes/

https://gardener.cloud/050-tutorials/content/howto/prometheus/

https://gardener.cloud/050-tutorials/content/howto/helm/


Using Azure and two helm charts:

http://www.allaboutwindowssl.com/2019/03/setup-prometheus-grafana-monitoring-on-azure-kubernetes-cluster-aks/



---
[Next step: 7. Terminate and free resources](../docs/98_free_resources.md)  
[Previous step: 5. Create cluster with Skaffold](../docs/05_cluster_skaffold.md)


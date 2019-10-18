
## Helm

### Installing client

https://helm.sh/docs/using_helm/#installing-helm


Windows
`choco install kubernetes-helm`
MacOs
`brew install kubernetes-helm`
Linux
`sudo snap install helm --classic`

### Installing Tiller, Kubernetes component

https://helm.sh/docs/using_helm/#installing-tiller

helm init --history-max 200

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

helm install --name my-release stable/prometheus-operator

 helm install --namespace monitoring --name prometheus stable/prometheus-operator

https://medium.com/@chris_linguine/how-to-monitor-your-kubernetes-cluster-with-prometheus-and-grafana-2d5704187fc8

helm delete my-release
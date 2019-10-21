# Azure Hipster Shop: AKS Microservices Demo

## 4. Get Kubectl credentials

Alternative 1. Using Azure-cli:
```
$ az aks get-credentials --resource-group SysTest-k8s-resources --name SysTest-k8s --overwrite
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
## Examine Kluster Dashboard

### AKS deployment of Dashboard

az aks browse --resource-group myResourceGroup --name myAKSCluster

See: https://docs.microsoft.com/en-us/azure/aks/kubernetes-dashboard

### General deployment of Dashboard

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml
kubectl proxy

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.


See: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

## Login with Docker to Azure Cointer Registry

```
$ docker login $(terraform output acr_uri) -u $(terraform output acr_user) -p $(terraform output acr_password)

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

```
$ set SKAFFOLD_DEFAULT_REPO="$(terraform output acr_uri)"
```

## Get Kubectl credentials

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
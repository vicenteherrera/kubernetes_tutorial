# Azure Hipster Shop: AKS Microservices Demo

## 1. Install prerequisites

You will need to install the following tools:

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest): To create Service Principal, its credentials and Kubernetes config.
* Docker: [linux](https://docs.docker.com/install/linux/docker-ce/ubuntu/) [mac](https://docs.docker.com/docker-for-mac/install/) [win](https://docs.docker.com/docker-for-windows/install/): Used by Skaffold to build and push images  .
* [Terraform](https://www.terraform.io/downloads.html): To automatically create infrastructure (resource group, managed Kubernetes cluster).
* [Skaffold](https://skaffold.dev/docs/getting-started/#installing-skaffold): To populate the cluster with all the items to run the microservices application (control plane, worker pods).
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/): Used by skaffold to control the cluster, we will also use it to inspect it from the command line.
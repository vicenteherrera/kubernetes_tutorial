# Azure Hipster Shop: AKS Microservices Demo

This project is an extension of the project "Hipster Shop: Cloud-Native Microservices Demo Application" from Google, available here: https://github.com/GoogleCloudPlatform/microservices-demo

The main focus here is to be able to deploy that demo project to Azure Kubernetes Service using best practices.

## 0. Getting started

### Introduction

![general_diagram](./docs/img/general_diagram.jpg)

### Limitations

The Stackdriver log monitor is specific to Google Cloud, the driver will try to connect several times and then give up.
See [microservices-demo/docs/development-principles.md](https://github.com/GoogleCloudPlatform/microservices-demo/blob/master/docs/development-principles.md) for more information.



This instructions comes with some __optional__, __alternative__ and __improvement__ parts. You can skip them if you like for a straigh forward procedure. The improvements will suggest additional task that you could investigate on your own to improve this excercise.

We will assume you work with a *bash* environment. 

If you are using Windows, most of the explanations here could be used in cmd.exe, but you will achieve full compatibily by using [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

### Contents

Follow these steps:

* [1. Installing prerequisites](./docs/01_prerequisites.md)
* [2. Initial Azure setup](./docs/02_setup_az_sp.md)
* [3. Provision infrastructure with Terraform](./docs/03_infra_terraform.md)
* [4. Get credentials](./docs/04_get_credentials.md)
* [5. Create cluster with Skaffold](./docs/05_cluster_skaffold.md)
* [6. Create cluster with Skaffold](./docs/06_helm.md)
* [7. Terminate and free resources](./docs/98_free_resources.md)
* [Appendix: Troubleshooting](./docs/99_troubleshooting.md)

---
[Next step: 1. Installing prerequisites](./doc/01_prerequisites.md)  

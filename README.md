# Azure Hipster Shop: AKS Microservices Demo

This project is an extension of the project "Hipster Shop: Cloud-Native Microservices Demo Application" from Google, available here: https://github.com/GoogleCloudPlatform/microservices-demo

The main focus here is to be able to deploy that demo project to Azure Kubernetes Service using best practices.

## Limitations

The Stackdriver log monitor is specific to Google Cloud, the driver will try to connect several times and then give up.
See microservices-demo/docs/development-principles.md

## Getting started

We will assume you work with a *bash* environment. 

If you are using Windows, most of the explanations here could be used in cmd.exe, but you will achieve full compatibily by using [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

Follow these steps:

* [1. Installing prerequisites](./doc/01_prerequisites.md)
* [2. Setting up Azure](./doc/02_setup_az_sp.md)
* [3. Create infrastructure with Terraform](./doc/03_infra_terraform.md)
* [4. Get credentials](./doc/04_get_credentials.md)
* [5. Create cluster with Skaffold](./doc/05_cluster_skaffold.md)
* [6. Terminate and free resources](./doc/98_free_resources.md)
* [Appendix: Troubleshooting](./doc/99_troubleshooting.md)

---
[Next step: 1. Installing prerequisites](./doc/01_prerequisites.md)

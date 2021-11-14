---
layout: frontpage
title: Kubernetes tutorial
description: Azure Kubernetes Service, Terraform, Helm, Prometheus, Grafana, Skaffold
---
# Kubernetes tutorial

Author: **Vicente Herrera** - [@vicen_herrera](https://twitter.com/vicen_herrera)  
Level: **Intermediate**  
Language: **English**  
Prerequisites: Basic knowledge in containers and Kubernetes  
Knowledge to learn: <span class="badge rounded-pill bg-danger white" style="color:white">Kubernetes</span> 
<span class="badge rounded-pill bg-danger white" style="color:white">Azure</span> 
<span class="badge rounded-pill bg-danger white" style="color:white">AKS</span>
<span class="badge rounded-pill bg-danger white" style="color:white">Terraform</span> 
<span class="badge rounded-pill bg-danger white" style="color:white">Helm</span> 
<span class="badge rounded-pill bg-danger white" style="color:white">Prometheus</span> 
<span class="badge rounded-pill bg-danger white" style="color:white">Grafana</span> 
<span class="badge rounded-pill bg-danger white" style="color:white">Skaffold</span>  


## Introduction

I built this tutorial when joining [Sysdig](https://sysdig.com){:target="_blank"} to showcase my knowledge in containers, Kubernetes and cloud.

As usual, it has grown old, for example it mentions Helm v2, including the Tiller component, where at the time of writing this updated intro v3 is out that doesn't require Tiller. Also there are many _improvements_ listed on each section, for ideas about how to improve the tutorial.

Tools used in the tutorial:
* Kubernetes: Using _Azure Kubernetes Service (AKS)_, but you could replace this for local _Minikube_ if you want.
* Terraform: Infrastructure as code, to create the cluster
* Helm: To deploy predefined services to the cluster
* Prometheus: To generate some metrics about cluster and services behaviour
* Grafana: To plot resource usage graphically
* Hipster Shop demo: To have a sample microservices architecture running
* Skaffold: To deploy and live modify the microservices

### Contents

[**Kubernetes tutorial**](./docs/00_getting_started.md){:class="solid-btn lesson"}  
[0. Getting started](./docs/00_getting_started.md){:class="solid-btn lesson"}  
[1. Prerequisites](./docs/01_prerequisites.md){:class="solid-btn lesson"}  
[2. Initial Azure resources setup](./docs/02_setup_az_sp.md){:class="solid-btn lesson"}  
[3. Provision infrastructure with Terraform](./docs/03_infra_terraform.md){:class="solid-btn lesson"}  
[4. Get credentials](./docs/04_get_credentials.md){:class="solid-btn lesson"}  
[5. Installing Prometheus and Grafana using Helm](./docs/05_helm.md){:class="solid-btn lesson"}  
[6. Deploy microservices with Skaffold](./docs/06_cluster_skaffold.md){:class="solid-btn lesson"}  
[7. Terminate and free resources](./docs/98_free_resources.md){:class="solid-btn lesson"}  
[Appendix: Troubleshooting](./docs/99_troubleshooting.md){:class="solid-btn lesson"}  



# Kubernetes tutorial

Author: **Vicente Herrera** - [@vicen_herrera](https://twitter.com/vicen_herrera)  

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

[Visit the tutorial website](https://vicenteherrera.com/kubernetes_tutorial)



## Set up the kubernetes cluster with Skaffold

```
$ cd ..
$ cd microservices-demo
$ skaffold run --default-repo $ACR_URI --tail

Generating tags...
 - testacr22.azurecr.io/emailservice -> testacr22.azurecr.io/emailservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/productcatalogservice -> testacr22.azurecr.io/productcatalogservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/recommendationservice -> testacr22.azurecr.io/recommendationservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/shippingservice -> testacr22.azurecr.io/shippingservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/checkoutservice -> testacr22.azurecr.io/checkoutservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/paymentservice -> testacr22.azurecr.io/paymentservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/currencyservice -> testacr22.azurecr.io/currencyservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/cartservice -> testacr22.azurecr.io/cartservice:v0.1.2-2-g2177813
 - testacr22.azurecr.io/frontend -> testacr22.azurecr.io/frontend:v0.1.2-2-g2177813
 - testacr22.azurecr.io/loadgenerator -> testacr22.azurecr.io/loadgenerator:v0.1.2-2-g2177813
 - testacr22.azurecr.io/adservice -> testacr22.azurecr.io/adservice:v0.1.2-2-g2177813
Tags generated in 16.110141ms
Checking cache...
 - testacr22.azurecr.io/emailservice: Found. Pushing
The push refers to repository [testacr22.azurecr.io/emailservice]
```

## Check the health of the cluster

```
$ kubectl get nodes
```

Check all pods

```
$ kubectl get pods --all-namespaces
```
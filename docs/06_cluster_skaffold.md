# Azure Hipster Shop: AKS Microservices Demo

## 5. Deploy microservices with Skaffold

Skaffold allows us to have a seamless development workflow with Kubernetes.

To continue you must have defined the environment variable `SKAFFOLD_DEFAULT_REPO` and logged in with Docker to your created ACR as described in previous section.

### Skaffold workflow

Skaffold uses a workflow to keep your source in sync with the Kubernetes cluster:

  * Collects and watches your source code for changes
  * Syncs files directly to pods when user marks them as syncable
  * Builds artifacts from the source code
  * Tests the built artifacts using container-structure-tests
  * Tags the artifacts
  * Pushes the artifacts to the ACR
  * Deploys the artifacts from the ACR to the AKS cluster
  * Monitors the deployed artifacts
  * Cleans up deployed artifacts on exit (Ctrl+C)

### Running the microservices application

The microservices-demo project has everything else we need for using Skaffold. We can just change to its directory to proceed.

```
$ cd ..
$ cd microservices-demo
$ skaffold run --tail

Generating tags...
 - systestacr.azurecr.io/emailservice -> systestacr.azurecr.io/emailservice:v0.1.2-2-g2177813
 - systestacr.azurecr.io/productcatalogservice -> systestacr.azurecr.io/productcatalogservice:v0.1.2-2-g2177813
 - systestacr.azurecr.io/recommendationservice -> systestacr.azurecr.io/recommendationservice:v0.1.2-2-g2177813
 - systestacr.azurecr.io/shippingservice -> systestacr.azurecr.io/shippingservice:v0.1.2-2-g2177813
 - systestacr.azurecr.io/checkoutservice -> systestacr.azurecr.io/checkoutservice:v0.1.2-2-g2177813
 - systestacr.azurecr.io/paymentservice -> systestacr.azurecr.io/paymentservice:v0.1.2-2-g2177813
 - systestacr.azurecr.io/currencyservice -> systestacr.azurecr.io/currencyservice:v0.1.2-2-g2177813
 - systestacr.azurecr.io/cartservice -> systestacr.azurecr.io/cartservice:v0.1.2-2-g2177813
 - systestacr.azurecr.io/frontend -> systestacr.azurecr.io/frontend:v0.1.2-2-g2177813
 - systestacr.azurecr.io/loadgenerator -> systestacr.azurecr.io/loadgenerator:v0.1.2-2-g2177813
 - systestacr.azurecr.io/adservice -> systestacr.azurecr.io/adservice:v0.1.2-2-g2177813
Tags generated in 16.110141ms
Checking cache...
 - systestacr.azurecr.io/emailservice: Found. Pushing
The push refers to repository [systestacr.azurecr.io/emailservice]
```

Skaffold will start its workflow, using the `src` files as sources for the microservices, and the files from `kubermentes-manifest` to deploy the Kubernetes associated resources.


Using the --tail switch, you will start to see messages in the console like these:

```
[cartservice-558bdc457b-g4bmt server] Checking CartService Health
[frontend-677bf4649b-78qq4 server] {"http.req.id":"c1c195cb-5ab4-46af-958b-9b43b70f854d","http.req.method":"GET","http.req.path":"/_healthz","http.resp.bytes":2,"http.resp.status":200,"http.resp.took_ms":0,"message":"request complete","session":"x-readiness-probe","severity":"debug","timestamp":"2019-10-22T03:55:32.234309421Z"}
[emailservice-54ffc447b8-q9md2 server] [SpanData(name='Recv.grpc.health.v1.Health.Check', context=SpanContext(trace_id=ac3badfd1dc14226b960f7189d85a926, span_id=None, trace_options=TraceOptions(enabled=True), tracestate=None), span_id='c76d223f1b5a4440', parent_span_id=None, attributes={'component': 'grpc'}, start_time='2019-10-22T03:55:32.329961Z', end_time='2019-10-22T03:55:32.330053Z', child_span_count=0, stack_trace=None, time_events=[<opencensus.trace.time_event.TimeEvent object at 0x7f20c823ccd0>, <opencensus.trace.time_event.TimeEvent object at 0x7f20c823e550>], links=[], status=None, same_process_as_parent_span=None, span_kind=1)]
```

The Hipster Shop demo uses a Stackdriver log monitor that is specific to Google Cloud, and its driver will try to connect several times and then give up. See [the official documentation](https://github.com/GoogleCloudPlatform/microservices-demo/blob/master/docs/development-principles.md) for more information.

When using the "run" command, you can push Ctrl+C to exit and the microservices application will continue to run. Also, changes to sources will not be synced to the cluster.

### Browsing the shop's website

Locate the IP that the load balancer is using, execute:

```
$ kubectl get service frontend-external

NAME                TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)        AGE
frontend-external   LoadBalancer   10.0.200.147   13.73.227.79   80:31971/TCP   12m
```

Then open the http URL using "EXTERNAL-IP" address to see the shop's web page:
http://13.73.227.79

If it shows `<pending>`, you have to wait till the external IP has been provisioned. Sometimes it can take more than 5 minutes for it to be available.

![Hipster Shop's web page](../docs/img/shop.png)

### Developing and Skaffold

If you want to develop code for the microservices and have Skaffold execute it's workflow to automatically publish it to the Kubernetes cluster whenever it detects a change, use:

```
$ skaffold dev
```

The "dev" command, when interrupted with Ctrl+C, will delete all resources created in the cluster when the microservices where deployed.

While it is running, if you change any of the source files of `src` folder, you will automatically trigger the workflow that deploys the change to the corresponding container in the cluster.

If you are deploying to a local Kubernetes installation with Minikube and a standard profile, or Docker for desktop, pushing images to the registry is automatically skipped. To do the same in other cases, see the [official documentation here](https://skaffold.dev/docs/concepts/local_development/).

## Optional: Check the status of the cluster

To get all the nodes on the default namespace in the cluster, use:

```
$ kubectl get nodes
```

Check pods from all namespaces with:

```
$ kubectl get pods --all-namespaces
```

_Improvement_: With the default configuration, Skaffold doesn't use your provisioned public IP. Change it to use that.

_Improvement_: You could set up a CI/CD pipeline in Azure Devops portal linked to a git repository to automatically deploy the cluster when a commit to __master__ branch is done.

---
[Next step: 7. Terminate and free resources](../docs/98_free_resources.md)  

[Previous step: 5. Installing Prometheus and Grafana using Helm](../docs/05_helm.md)
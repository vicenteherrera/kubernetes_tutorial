## Troubleshooting

### Not available Microsoft.Network

### One or more node with status 'CrashLoopBackOff'

```
$ kubectl get pods
$ kubectl describe pod pod-crashloopbackoff-7f7c556bf5-9vc89
$ kubectl logs pod-crashloopbackoff-7f7c556bf5-9vc89 im-crashing
$ kubectl describe pod pod-crashloopbackoff-liveness-probe-7564df8646-v96tq
```
See https://sysdig.com/blog/debug-kubernetes-crashloopbackoff/
https://managedkube.com/kubernetes/pod/failure/crashloopbackoff/k8sbot/troubleshooting/2019/02/12/pod-failure-crashloopbackoff.html

### failed to initialize stackdriver exporter: stackdriver: 

```
failed to initialize stackdriver exporter: stackdriver:  google: could not find default credentials. See https://developers.google.com/accounts/docs/application-default-credentials for more information
```

Stackdriver only exist in the Google Cloud Environment

### Node size

Node must have at least 6 Gb RAM and 32 Gb hard disk. 1 Node for testing, 3 for "production".

### Service principal should have permission

### RBCA not enabled
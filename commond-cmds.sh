# K8s uses the `default` namespace by default. to use another namespace you should use `--namespace=<ns-id>`
kubectl --namespace=<ns-id> get pods

# use `--all-namespaces` flag to interact with all namespaces
kubectl --all-namespaces get pods  # kca get pods

# use `set-context` to change namespaces `--namespace`, users `--users`, clusters `--clusters` more permanently you should use
kubectl config set-context <new-context-name> --namespace=<ns-name>  # kcsc <new-context-name> --namespace=<ns-name>

# use `kubectl get` to list all resources in the current namespace
kubectl get pods # kgp

# use `get <resource-name> <resource-obj>` to get details only about that object of that resource
kubectl get <resource-name> <resource-obj>
# NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
# kube-system   event-exporter-v0.2.4-5f88c66fb7-vhc72    2/2     Running   0          84m

# use `-o wide` to view more details about objects
kubectl get <resource-name> -o wide
kubectl get <resource-name> <resource-obj> -o wide
# NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE   IP           NODE                   NOMINATED NODE   READINESS GATES
# kube-system   event-exporter-v0.2.4-5f88c66fb7-vhc72    2/2     Running   0          83m   10.8.2.3     gke-standard-cluster   <none>           <none>

# use `-o json/yaml` to view more details about objects in yaml or json
kubectl get <resource-name> -o yaml
kubectl get <resource-name> <resource-obj> -o yaml

# use `-o jsonpath` and `--tempalte` to extract a specific field from object
kubectl get pods my-pod -o jsonpath --template={.status.podIP}  # kgp my-pod -o jsonpath --template={.status.podIP}

# use `describe` to get more info about particular object
kubectl describe <resource-name> <resource-obj>  # kdp my-pod
# This will provide a rich multiline human-readable description of the object as well as any other relevant, related objects and events in the Kubernetes cluster.

# use `apply` to create or update objects from a yaml or json file
# `apply` ,in case of updating, will only update objects that have updates only
kubectl apply -f <fild-name>  # kaf <file-name>

# use `--dry-run` flag to see what `apply` will do without actually doing anything
kubectl apply -f <file-name> --dry-run  # kaf <file-name> --dry-run

# use `edit-last-applied`, `set-last-applied`, and `view-last-applied` to show or manipulate previous configurations
kubectl apply -f <filename.yml> view-last-applied

# use `delete` to delete object or objects in a file
kubectl delete -f obj.yaml
kubectl delete <resource-name> <resource-obj>

# labels are a dictionary associated to a set of objects
# use `label` go add label to a certain object.
kubectl label <resource-name> <resource-obj> <label-key>=<label-value> # color=red

# use <label-key>- to delete a label from a resource
kubectl label <resource-name> <resource-obj> <label-key>- # color-


######################################## Debugging ########################################
# use `logs` to a pod to show its stdout & stderr
kubectl logs <pod-name>

# use -f to follow logs
kubectl logs <pod-name> -f

# use -c to show logs to a specific container in a pod
kubectl logs <pod-name> -c <container-name>

# you can use `exec` and `attach` as it's used in docker
kubectl exec -it <pod-name> -- bash
kubectl attach -it <pod-name>

# use `cp` to and from a container
kubectl cp <pod-name>:</path/to/remote/file> </path/to/local/file>
kubectl cp </path/to/local/file> <pod-name>:</path/to/remote/file>

# use `port-forward` to access pods via network
kubectl port-forward <pod-name> 8080:80  # <local-port>:<remote-port>

# you can use `port-forward` with services
kubectl port-forward services/<service-name> 8080:80  # <local-port>:<remote-port>

# use `top` to check which nodes, pods are taking most resources
kubectl top nodes
# NAME                     CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
# gke-standard-cluster-1   51m          5%     707Mi           26%
# gke-standard-cluster-1   50m          5%     674Mi           25%
# gke-standard-cluster-1   42m          4%     628Mi           23%


# Kubernetes

```powershell
#  k8s & minikube installation
choco install kubernetes-cli minikube

# helm installation
choco install kubernetes-helm

# check versions
minikube version
kubectl version --client
docker --version

# create minikube instance
minikube start --vm-driver hyperv|virtualbox
minikube start --kubernetes-version 1.16.2
minikube start --cpus 4 --memory 8g

# check status
minikube status
kubectl version
kubectl cluster-info

# enable ingress
minikube addons enable ingress
minikube addons list
kubectl get pod --namespace=kube-system

# build docker image manually inside MiniKube VM
minikube docker-env
& minikube docker-env | Invoke-Expression

# test app in k8s with kubectl run
kubectl run hello --image=hello:v1

# cheatsheet
https://kubernetes.io/docs/reference/kubectl/cheatsheet/

# all
kubectl get all

# pods
kubectl get pod
kubectl get pod [pod_name] -o wide # look up pod
kubectl delete pod [pod_name] --wait=false # delete pod without waiting
kubectl get pods --namespace=monitoring

# deployments
kubectl get deployment
kubectl delete deployment
kubectl scale deployment [deployment_name] --replicas=3 --record # scale deployment
kubectl rollout history deployment [deployment_name] # check history
kubectl get deployment [deployment_name] -o yaml --export > hello-deployment.yaml # export

# create from yaml

k apply -f hi-deployment.yaml # deployment
k apply -f hi-service.yaml # service
k apply -f hi-ingres.yaml # ingress


# ClusterIP (default -  "virtual" IP accessible inside k8s cluster)
# NodePort (expose on all nodes on the same port, 30000-32768 by default)
# LoadBalancer (expose service by using external LB - that must be enabled/configured by a cloud provider. Minikube simulates this with using a  NodePort and  command  minikube service name_of_our_service) 
# ExternalName (DNS CNAME record that points somewhere outside the cluster)
kubectl expose deployment [deployment_name] --port=8080 --target-port=8080 --type=LoadBalancer

# services
kubectl get service # get services

# other
kubectl logs [pod_name] # check logs
kubectl run -ti --rm alpine --image=alpine # run an interactive pod
Invoke-WebRequest -Uri "uri" # send http get request from powershell

# minikube
minikube service list
minikube service [service_name] --url # check service url
minikube service [service_name] # open service in browser
minikube service [service_name] -n monitoring
minikub ssh curl http://[ip]:[port]
minikube ip # get ip

# blue green deployment
# in ingress yaml change serviceName from 1 to 2

kubectl get deployment [name] -o wide --watch
kubectl get pod --watch

# monitoring 
helm repo add stable https://kubernetes-charts.storage.googleapis.com/ # helm

k create ns monitoring # create namespace for monitoring
helm install --namespace monitoring prometheus stable/prometheus # install prometheus
helm install --namespace=monitoring grafana --set=adminUser=admin --set=adminPassword=admin --set=service.type=NodePort stable/grafana # install grafana

```
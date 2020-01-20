# Kubernetes

```powershell
#  k8s & minikube installation
choco install kubernetes-cli minikube

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

```
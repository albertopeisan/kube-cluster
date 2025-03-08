```bash
minikube start --cpus 4 --memory 4096 --disk-size 20g --nodes 5 --base-image docker.io/kicbase/stable:v0.0.46 -p kube-cluster
minikube profile kube-cluster
minikube addons enable ingress
minikube addons enable metrics-server
```

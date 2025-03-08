#!/bin/bash

# Set the minikube profile
minikube profile kube-cluster

# Start minikube
minikube start

# Open the minikube dashboard URL
minikube dashboard --url &

# Forward the port for Argo CD server
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

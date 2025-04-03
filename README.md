# Multi-node Minikube cluster with ArgoCD

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup a Multi-Node Minikube Cluster](#setup-a-multi-node-minikube-cluster)
  - [Step 1: Install Minikube and kubectl](#step-1-install-minikube-and-kubectl)
  - [Step 2: Start the Multi-Node Minikube Cluster](#step-2-start-the-multi-node-minikube-cluster)
- [Optional: Install ArgoCD](#optional-install-argocd)
  - [Step 1: Install ArgoCD](#step-1-install-argocd)
  - [Step 2: Access the ArgoCD UI](#step-2-access-the-argocd-ui)
  - [Step 3: Update the Admin Password](#step-3-update-the-admin-password)

## Overview

This repository provides documentation on how to set up a multi-node Minikube cluster and optionally install ArgoCD. Minikube is a tool that makes it easy to run a single-node Kubernetes cluster locally, but with the added steps in this guide, you can create a multi-node cluster for testing and development purposes.

## Prerequisites

Before starting, ensure you have the following installed on your system:
- **Docker**: A container runtime. Minikube supports Docker, Podman, and other runtimes.
- **kubectl**: The Kubernetes command-line tool.
- **Minikube**: The local Kubernetes cluster manager.

## Setup a Multi-Node Minikube Cluster

### Step 1: Install Minikube and kubectl

First, ensure that `kubectl` and `minikube` are installed on your system.

#### Install kubectl

```bash
# On macOS using Homebrew
brew install kubectl
```

```bash
# On Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

#### Install minikube

```bash
# On macOS using Homebrew
brew install minikube
```

```bash
# On Linux
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### Step 2: Start the Multi-Node Minikube Cluster

To start a multi-node Minikube cluster, use the following commands:

```bash
# Start a multi-node cluster with 5 nodes, each node with 4 vCPUs, 2GB memory, and 10GB disk. Modify this parameters to your needs
# Enables ingress and metrics-server addons
minikube start --cpus 4 --memory 2048 --disk-size 10g --nodes 5 --base-image docker.io/kicbase/stable:v0.0.46 -p kube-cluster
minikube profile kube-cluster
minikube addons enable ingress
minikube addons enable metrics-server

# Verify that the cluster is running
kubectl get nodes
```

This will create a Minikube cluster with 5 nodes. You can adjust the number of nodes by changing the `--nodes` parameter.

## Optional: Install ArgoCD

### Step 1: Install ArgoCD

To install ArgoCD, use the following commands:

```bash
# Create a namespace for ArgoCD
kubectl create namespace argocd

# Deploy ArgoCD
kubectl apply -f ./argocd/manifests/argocd.yaml -n argocd
```

### Step 2: Access the ArgoCD UI

To access the ArgoCD UI, you need to port-forward the ArgoCD server:

```bash
# Port-forward the ArgoCD server
kubectl -n argocd port-forward svc/argocd-server 8080:443 &
```

Open your web browser and navigate to `http://localhost:8080`.

The default username is `admin` and the password can be obtained using:

```bash
# Get the initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

### Step 3: Update the admin password

To update the ArgoCD admin password, follow these steps:

1. **Install the ArgoCD CLI**:

    ```bash
    # On macOS using Homebrew
    brew install argocd
    ```

    ```bash
    # On Linux
    curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    chmod +x /usr/local/bin/argocd
    ```

2. **Login to ArgoCD**:

    ```bash
    argocd login localhost:8080 --insecure --username admin
    ```
   
    Use the initial password you obtained in Step 2.

3. **Update the Admin Password**:

   ```bash
   argocd account update-password --account admin --current-password <current-password> --new-password <new-password>
   ```

Replace `<current-password>` and `<new-password>` with your actual current and new passwords.

## Conclusion

With these steps, you should have a multi-node Minikube cluster up and running, and optionally ArgoCD installed for managing your applications.

If you encounter any issues or have any questions, feel free to open an issue in this repository.
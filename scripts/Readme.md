scripts/README.md

# Kubernetes Automation Scripts

## Execution Order

1. 01-controlplane-setup.sh
   - Installs Docker/containerd
   - Installs Kubernetes components
   - Initializes Kubernetes control plane

2. 02-worker-node-setup.sh
   - Installs container runtime
   - Installs kubeadm/kubelet/kubectl
   - Prepares worker node

3. 03-install-calico.sh
   - Installs Kubernetes networking

4. 04-deploy-application.sh
   - Deploys Cloud Employee Management Platform

5. 05-verify-cluster.sh
   - Validates nodes, pods and services
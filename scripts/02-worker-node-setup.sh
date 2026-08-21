#!/bin/bash

#############################################################
# Cloud Employee Management Platform
#
# Script   : Kubernetes Worker Node Setup
# Platform : Azure Ubuntu VM
# Kubernetes : v1.33
# Runtime  : containerd
#
#############################################################

set -e

echo "=============================================="
echo "Starting Kubernetes Worker Node Setup"
echo "=============================================="


# STEP 1 - Configure Hostname

sudo hostnamectl set-hostname cemp-worker01

echo "Worker hostname configured"



# STEP 2 - Update Ubuntu

sudo apt update
sudo apt upgrade -y



# STEP 3 - Install Docker Prerequisites

sudo apt install -y \
ca-certificates \
curl \
gnupg \
lsb-release



# STEP 4 - Configure Docker Repository


sudo install -m 0755 -d /etc/apt/keyrings


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor \
-o /etc/apt/keyrings/docker.gpg


sudo chmod a+r /etc/apt/keyrings/docker.gpg



echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list



# STEP 5 - Install Docker and containerd


sudo apt update


sudo apt install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin



sudo systemctl enable docker

sudo systemctl start docker


docker --version



# STEP 6 - Configure containerd


sudo mkdir -p /etc/containerd


containerd config default | \
sudo tee /etc/containerd/config.toml



sudo sed -i \
's/SystemdCgroup = false/SystemdCgroup = true/' \
/etc/containerd/config.toml



sudo systemctl restart containerd


sudo systemctl enable containerd



echo "containerd configured successfully"



# STEP 7 - Disable Swap


sudo swapoff -a


sudo sed -i '/ swap / s/^/#/' /etc/fstab



# STEP 8 - Enable Kubernetes Kernel Modules


cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf

overlay
br_netfilter

EOF



sudo modprobe overlay

sudo modprobe br_netfilter



# STEP 9 - Configure Kubernetes Networking


cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf

net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1

EOF



sudo sysctl --system



# STEP 10 - Install Kubernetes Components


sudo apt-get update


sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gpg



sudo mkdir -p -m 755 /etc/apt/keyrings



curl -fsSL \
https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | \
sudo gpg --dearmor \
-o /etc/apt/keyrings/kubernetes-apt-keyring.gpg



echo \
'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | \
sudo tee /etc/apt/sources.list.d/kubernetes.list



sudo apt-get update



sudo apt-get install -y \
kubelet \
kubeadm \
kubectl



sudo apt-mark hold kubelet kubeadm kubectl



sudo systemctl enable kubelet



# STEP 11 - Verify Installation


echo "Checking Kubernetes Versions"


kubeadm version

kubectl version --client



# STEP 12 - Join Cluster


echo ""
echo "=============================================="
echo "Worker Node Preparation Completed"
echo "=============================================="

echo ""
echo "Now execute the kubeadm join command generated"
echo "from the Control Plane node:"
echo ""

echo "Example:"
echo "kubeadm join <CONTROL-PLANE-IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>"


echo ""

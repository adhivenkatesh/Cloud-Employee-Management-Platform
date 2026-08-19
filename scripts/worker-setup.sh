#!/bin/bash

#############################################################
# Worker-Node Setup Script
# Cloud Employee Management Platform
# Version : 1.0
#############################################################

  
# STEP 1 - Update Ubuntu
sudo apt update
sudo apt upgrade -y
# STEP 2 - Install Docker Prerequisites
sudo apt install -y ca-certificates curl gnupg lsb-release
# STEP 3 - Add Docker Repository 
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# STEP 4 - Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker --version

# STEP 5 - Allow Docker Without sudo
sudo usermod -aG docker $USER
newgrp docker

docker run hello-world
# STEP 6 - Disable Swap
free -h
sudo swapoff -a
free -h

# STEP 7 - Enable Kernel Modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter
# STEP 8 - Configure Networking
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
EOF
sudo sysctl --system
#Verify expected result 1 
cat /proc/sys/net/ipv4/ip_forward
# STEP 9 - Configure containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo nano /etc/containerd/config.toml
# SystemdCgroup = true
# Restart and verify 
sudo systemctl restart containerd
sudo systemctl status containerd
# STEP 10 - Install Kubernetes
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key | \
sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.36/deb/ /' | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
#verify versions 
kubeadm version
kubectl version --client

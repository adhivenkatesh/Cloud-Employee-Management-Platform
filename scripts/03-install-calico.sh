#!/bin/bash

#############################################################
# Cloud Employee Management Platform
#
# Script   : Install Calico Network Plugin
# Platform : Kubernetes
# CNI      : Calico
#
#############################################################

set -e

echo "=============================================="
echo "Installing Calico Network Plugin"
echo "=============================================="


echo "Applying Calico manifest..."

kubectl apply -f \
https://raw.githubusercontent.com/projectcalico/calico/v3.30.3/manifests/calico.yaml


echo ""
echo "Waiting for Calico pods..."

sleep 30


echo ""
echo "Checking Calico Status"


kubectl get pods -n kube-system


echo ""
echo "Checking Nodes"


kubectl get nodes


echo ""
echo "=============================================="
echo "Calico Installation Completed"
echo "=============================================="
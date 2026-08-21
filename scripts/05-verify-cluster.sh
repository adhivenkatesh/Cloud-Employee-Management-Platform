#!/bin/bash

#############################################################
# Cloud Employee Management Platform
#
# Script   : Kubernetes Cluster Verification
#
#############################################################

set -e


echo "=============================================="
echo "Kubernetes Cluster Verification"
echo "=============================================="


echo ""
echo "1. Kubernetes Nodes"
echo "-------------------"

kubectl get nodes



echo ""
echo "2. All Pods"
echo "-------------------"

kubectl get pods -A



echo ""
echo "3. Services"
echo "-------------------"

kubectl get svc -A



echo ""
echo "4. ConfigMaps"
echo "-------------------"

kubectl get configmaps -A



echo ""
echo "5. Secrets"
echo "-------------------"

kubectl get secrets -A



echo ""
echo "=============================================="
echo "Cluster Verification Completed"
echo "=============================================="
#!/bin/bash

#############################################################
# Cloud Employee Management Platform
#
# Script   : Application Deployment
# Platform : Kubernetes
#
#############################################################

set -e


echo "=============================================="
echo "Deploying Cloud Employee Management Platform"
echo "=============================================="


BASE_PATH="../kubernetes"


echo "Creating Namespace"

kubectl apply -f $BASE_PATH/namespace.yaml


echo "Applying ConfigMap"

kubectl apply -f $BASE_PATH/configmap.yaml


echo "Applying Secret"

kubectl apply -f $BASE_PATH/secret.yaml


echo "Deploying Application"

kubectl apply -f $BASE_PATH/deployment.yaml


echo "Creating Service"

kubectl apply -f $BASE_PATH/service.yaml



echo ""
echo "Checking Deployment"


kubectl get deployments -A


echo ""
echo "Checking Pods"


kubectl get pods -A


echo ""
echo "=============================================="
echo "Application Deployment Completed"
echo "=============================================="
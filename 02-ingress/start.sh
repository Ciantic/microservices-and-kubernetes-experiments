#!/bin/bash

set -e

# Setup
kind create cluster --config kube-config.yaml
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update

# https://github.com/helm/charts/tree/master/stable/nginx-ingress
helm3 install my-ingress stable/nginx-ingress --set controller.service.type=NodePort --set controller.service.nodePorts.http=30080  --set controller.service.nodePorts.https=30443

kubectl create -f service.yaml

echo "Waiting 120 seconds for nginx to come online..."
sleep 120s
curl http://localhost:30080/test

# Teardown
read -p "Press [Enter] to teardown..."
export KUBECONFIG=""
kind delete cluster --name kind
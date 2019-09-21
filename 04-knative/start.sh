#!/bin/bash

set -e

# Setup
kind create cluster --config kube-config.yaml
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

./setup-istio.sh

echo "Waiting 120 seconds for istio setup to become operational..."
sleep 120s

./setup-knative.sh

echo "Waiting 240 seconds for knative setup to become operational..."
sleep 240s

kubectl get pods --namespace knative-serving
kubectl get pods --namespace knative-eventing
kubectl get pods --namespace knative-monitoring

./setup-helloworld.sh

# Teardown
read -p "Press [Enter] to teardown..."
export KUBECONFIG=""
kind delete cluster --name kind
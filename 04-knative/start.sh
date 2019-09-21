#!/bin/bash

set -e

# This has to be the most awful way to install any software, usually it doesn't
# work, if it does it takes literally 15 minutes or more for the pods to settle.
# And all for hello world?

# Setup
kind create cluster --config kube-config.yaml
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

./setup-istio.sh

echo "Waiting 120 seconds for istio setup to become operational..."
sleep 120s

./setup-knative.sh

echo "Waiting 260 seconds for knative setup to become operational..."
sleep 260s

kubectl get pods --namespace knative-serving
kubectl get pods --namespace knative-eventing
kubectl get pods --namespace knative-monitoring

./setup-helloworld.sh

# Teardown
read -p "Press [Enter] to teardown..."
export KUBECONFIG=""
kind delete cluster --name kind
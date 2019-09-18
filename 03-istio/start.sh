#!/bin/bash

set -e

# Setup
kind create cluster --config kube-config.yaml
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

./setup-istio.sh

echo "Waiting 20 seconds for istio setup to become operational..."
sleep 20s

./setup-bookinfo.sh

echo "Waiting 300 seconds for the book info to come online..."
sleep 300s

./test-bookinfo.sh

# Teardown
read -p "Press [Enter] to teardown..."
export KUBECONFIG=""
kind delete cluster --name kind
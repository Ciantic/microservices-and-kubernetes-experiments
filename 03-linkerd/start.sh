#!/bin/bash

set -e

# Setup
kind create cluster --config kube-config.yaml
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

./setup-linkerd.sh

curl -sL https://run.linkerd.io/emojivoto.yml \
  | sed 's#LoadBalancer#NodePort#' \
  | ./linkerd inject - \
  | kubectl apply -f -

# kubectl get service/web-svc -n emojivoto -o json
kubectl patch svc web-svc -n emojivoto --type=json --patch '[{"op": "replace", "path": "/spec/ports/0/nodePort", "value": 31380}]'

./linkerd -n emojivoto check --proxy

# ./linkerd -n emojivoto top deploy
# ./linkerd -n emojivoto tap deploy/web

# Without linkerd service mesh
# curl -sL https://run.linkerd.io/emojivoto.yml \
#   | sed 's#LoadBalancer#NodePort#' \
#   | kubectl apply -f -

# Teardown
read -p "Press [Enter] to teardown..."
export KUBECONFIG=""
kind delete cluster --name kind
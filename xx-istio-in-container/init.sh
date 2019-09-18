#!/bin/sh

echo "blaa"

# Setup single node kind cluster
# echo "kind: Cluster
# apiVersion: kind.sigs.k8s.io/v1alpha3
# nodes:
# - role: control-plane
#   extraPortMappings:
#   - containerPort: 31380
#     hostPort: 31380" >> /kube-config.yaml    
# kind create cluster --config kube-config.yaml
# export KUBECONFIG="$(kind get kubeconfig-path)"

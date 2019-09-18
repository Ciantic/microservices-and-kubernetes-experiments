#!/bin/bash
set -e

echo "Nginx example, you should see 'Welcome to nginx!' page..."

# Setup
kind create cluster --config kube-config.yaml
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

kubectl create -f service.yaml

# Alternatively using imperative calls
# kubectl run nginx --image=nginx --replicas=1
# kubectl expose deploy nginx --port=80 --target-port=80 --type=NodePort
# kubectl patch svc nginx --type=json -p '[{"op": "replace", "path": "/spec/ports/0/nodePort","value":30080}]'

# Wait for nginx to come online (50 seconds might not be enough)
echo "Waiting 50s, for nginx to come online..."
sleep 50s
curl http://localhost:30080

# Teardown
read -p "Press [Enter] to teardown..."
export KUBECONFIG=""
kind delete cluster --name kind
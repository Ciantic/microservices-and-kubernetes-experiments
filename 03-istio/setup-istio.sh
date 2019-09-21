#!/bin/bash
set -e

ISTIO_VERSION="1.3.0"

# Get latest istio
if [[ ! -d "istio" ]]; then
    mkdir istio
    cd istio
    OSEXT="linux"
    ISTIO_URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-${OSEXT}.tar.gz"
    curl $ISTIO_URL -L -o istio.tar.gz
    tar -xvzf istio.tar.gz --strip 1
    rm istio.tar.gz
    cd ..
fi

kubectl create namespace istio-system
kubectl label namespace default istio-injection=enabled

# Install
for i in istio/install/kubernetes/helm/istio-init/files/crd*yaml; 
do 
    kubectl apply -f $i; 
done
sleep 3s # This really is installation step!
cat istio/install/kubernetes/istio-demo.yaml \
    | sed 's#LoadBalancer#NodePort#' \
    | kubectl apply -f -

# kubectl patch svc istio-ingressgateway -n istio-system --type=json --patch '[{"op": "replace", "path": "/spec/type", "value": "NodePort"}]'

# Using Helm3 does not work, it is deprecated by istio team:
# https://github.com/istio/istio/issues/17167

kubectl get all -n istio-system

echo "Istio has been set up."
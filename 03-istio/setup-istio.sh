#!/bin/bash
set -e

# Get latest istio
if [[ ! -d "istio" ]]; then
    mkdir istio
    cd istio
    ISTIO_URL=$(curl -s https://api.github.com/repos/istio/istio/releases/latest \
        | grep "https://.*linux.tar.gz\"" \
        | cut -d '"' -f 4)
    curl $ISTIO_URL -L -o istio.tar.gz
    tar -xvzf istio.tar.gz --strip 1
    rm istio.tar.gz
    cd ..
fi

# Setup default namespace with automatic istio injection
kubectl label namespace default istio-injection=enabled

# CRD's
for i in istio/install/kubernetes/helm/istio-init/files/crd*yaml; 
do 
    kubectl apply -f $i; 
done

sleep 3s # This really is installation step!

kubectl apply -f istio/install/kubernetes/istio-demo.yaml
kubectl patch svc istio-ingressgateway -n istio-system --type=json --patch '[{"op": "replace", "path": "/spec/type", "value": "NodePort"}]'

kubectl get all -n istio-system
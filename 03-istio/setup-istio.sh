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

kubectl create namespace istio-system
kubectl label namespace default istio-injection=enabled

# Install
for i in istio/install/kubernetes/helm/istio-init/files/crd*yaml; 
do 
    kubectl apply -f $i; 
done
sleep 3s # This really is installation step!
kubectl apply -f istio/install/kubernetes/istio-demo.yaml
kubectl patch svc istio-ingressgateway -n istio-system --type=json --patch '[{"op": "replace", "path": "/spec/type", "value": "NodePort"}]'

# # helm repo
# helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.3.0/charts/
# helm repo update

# # Install crds
# helm install istio-init istio.io/istio-init --namespace istio-system

# # See https://github.com/helm/helm/issues/2994 for the deleting cache
# rm -rf ~/.kube/cache/discovery/

# sleep 3s # This really is installation step!

# # Install istio
# helm install istio istio.io/istio \
#     --namespace istio-system \
#     --values istio/install/kubernetes/helm/istio/values-istio-demo.yaml \
#     --set gateways.istio-ingressgateway.type=NodePort


kubectl get all -n istio-system
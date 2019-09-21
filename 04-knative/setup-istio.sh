#!/bin/bash

set -e

# Following https://knative.dev/docs/install/installing-istio/#installing-istio-with-sidecar-injection

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

# helm2 template istio/install/kubernetes/helm/istio-init \
#     --name istio-init \
#     --namespace istio-system \
#     | kubectl apply -f -

for i in istio/install/kubernetes/helm/istio-init/files/crd*yaml; 
do 
    kubectl apply -f $i; 
done

sleep 3s
helm2 template --namespace=istio-system \
  --set prometheus.enabled=false \
  --set mixer.enabled=false \
  --set mixer.policy.enabled=false \
  --set mixer.telemetry.enabled=false \
  `# Pilot doesn't need a sidecar.` \
  --set pilot.sidecar=false \
  --set pilot.resources.requests.memory=128Mi \
  `# Disable galley (and things requiring galley).` \
  --set galley.enabled=false \
  --set global.useMCP=false \
  `# Disable security / policy.` \
  --set security.enabled=false \
  --set global.disablePolicyChecks=true \
  `# Disable sidecar injection.` \
  --set sidecarInjectorWebhook.enabled=false \
  --set global.proxy.autoInject=disabled \
  --set global.omitSidecarInjectorConfigMap=true \
  `# Set gateway pods to 1 to sidestep eventual consistency / readiness problems.` \
  --set gateways.istio-ingressgateway.autoscaleMin=1 \
  --set gateways.istio-ingressgateway.autoscaleMax=1 \
  `# Set pilot trace sampling to 100%` \
  --set pilot.traceSampling=100 \
  --set gateways.istio-ingressgateway.type=NodePort \
  istio/install/kubernetes/helm/istio \
  | kubectl apply -f -

# # Default setup with injection
# helm2 template --namespace=istio-system \
#     --set sidecarInjectorWebhook.enabled=true \
#     `#--set sidecarInjectorWebhook.enableNamespacesByDefault=true` \
#     --set global.proxy.autoInject=disabled \
#     --set global.disablePolicyChecks=true \
#     --set prometheus.enabled=false \
#     `# Disable mixer prometheus adapter to remove istio default metrics.` \
#     --set mixer.adapters.prometheus.enabled=false \
#     `# Disable mixer policy check, since in our template we set no policy.` \
#     --set global.disablePolicyChecks=true \
#     `# Set gateway pods to 1 to sidestep eventual consistency / readiness problems.` \
#     --set gateways.istio-ingressgateway.autoscaleMin=1 \
#     --set gateways.istio-ingressgateway.autoscaleMax=1 \
#     --set gateways.istio-ingressgateway.resources.requests.cpu=500m \
#     --set gateways.istio-ingressgateway.resources.requests.memory=256Mi \
#     `# More pilot replicas for better scale` \
#     --set pilot.autoscaleMin=2 \
#     `# Set pilot trace sampling to 100%` \
#     --set pilot.traceSampling=100 \
#     `# Gateway` \
#     --set gateways.istio-ingressgateway.type=NodePort \
#     istio/install/kubernetes/helm/istio \
#     | kubectl apply -f -

kubectl label namespace default istio-injection=enabled
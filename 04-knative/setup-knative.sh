#!/bin/bash

# https://knative.dev/docs/install/knative-with-minikube/

# Selector
kubectl apply --selector knative.dev/crd-install=true \
    -f https://github.com/knative/serving/releases/download/v0.8.0/serving.yaml \
    -f https://github.com/knative/eventing/releases/download/v0.8.0/release.yaml \
    -f https://github.com/knative/serving/releases/download/v0.8.0/monitoring.yaml

sleep 3s

# Apply
kubectl apply \
    -f https://github.com/knative/serving/releases/download/v0.8.0/serving.yaml \
    -f https://github.com/knative/eventing/releases/download/v0.8.0/release.yaml \
    -f https://github.com/knative/serving/releases/download/v0.8.0/monitoring.yaml

# Second time it usually works, see https://github.com/knative/docs/issues/817
kubectl apply \
    -f https://github.com/knative/serving/releases/download/v0.8.0/serving.yaml \
    -f https://github.com/knative/eventing/releases/download/v0.8.0/release.yaml \
    -f https://github.com/knative/serving/releases/download/v0.8.0/monitoring.yaml

echo "Waiting 20 seconds for knative setup to become operational..."
sleep 20s

kubectl get pods --namespace knative-serving
kubectl get pods --namespace knative-eventing
kubectl get pods --namespace knative-monitoring
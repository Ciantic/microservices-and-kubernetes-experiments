#!/bin/bash

# Following https://knative.dev/docs/install/knative-with-minikube/

# Selector
kubectl apply --selector knative.dev/crd-install=true \
   --filename https://github.com/knative/serving/releases/download/v0.9.0/serving.yaml \
   --filename https://github.com/knative/eventing/releases/download/v0.9.0/release.yaml \
   --filename https://github.com/knative/serving/releases/download/v0.9.0/monitoring.yaml
sleep 3s
kubectl apply --selector knative.dev/crd-install=true \
   --filename https://github.com/knative/serving/releases/download/v0.9.0/serving.yaml \
   --filename https://github.com/knative/eventing/releases/download/v0.9.0/release.yaml \
   --filename https://github.com/knative/serving/releases/download/v0.9.0/monitoring.yaml

sleep 3s

# Do it twice! https://github.com/knative/serving/issues/2940
# First time throws error:
# error: unable to recognize "https://github.com/knative/serving/releases/download/v0.9.0/serving.yaml": no matches for kind "Image" in version "caching.internal.knative.dev/v1alpha1"
kubectl apply \
    -f https://github.com/knative/serving/releases/download/v0.9.0/serving.yaml \
    -f https://github.com/knative/eventing/releases/download/v0.9.0/release.yaml \
    -f https://github.com/knative/serving/releases/download/v0.9.0/monitoring.yaml
sleep 3s
kubectl apply \
    -f https://github.com/knative/serving/releases/download/v0.9.0/serving.yaml \
    -f https://github.com/knative/eventing/releases/download/v0.9.0/release.yaml \
    -f https://github.com/knative/serving/releases/download/v0.9.0/monitoring.yaml

#!/bin/bash
set -e

kubectl apply -f istio/samples/bookinfo/platform/kube/bookinfo.yaml

sleep 20s

# Test the intrapod connections
RATINGS_POD_NAME="$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')"
PRODPAGE_TITLE="$(kubectl exec -it $RATINGS_POD_NAME -c ratings -- curl productpage:9080/productpage | grep '<title>')"
if [[ "$PRODPAGE_TITLE" != *"Simple Bookstore App"* ]]; then
    echo "ERROR: Failed to call between ratings and productpage, has the bookinfo started yet?"
    exit 1
fi

# Test the 
echo "Book info started successfully."
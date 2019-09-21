#!/bin/bash

kubectl apply -f helloworld-go-service.yaml

echo "Trying 3 minutes for curling the hello world..."
for i in {1..6}; do 
    sleep 10s
    curl -H "Host: helloworld-go.default.example.com" http://127.0.0.1:31380
done
#!/bin/bash

kubectl apply -f helloworld-go-service.yaml

echo "Trying 3 minutes for curling the hello world..."
for i in {1..18}; do 
    sleep 10s
    echo "Trying ... $i"
    curl -H "Host: helloworld-go.default.example.com" http://127.0.0.1:31380/
done

# First question, if this is serverless, shouldn't the above loop just stop and
# be queued until the pod is running? It just gives 404 until it runs?

# On my machine this worked on 12th iteration of loop the first time, giving me:
#   Hello My Go Sample v1, neat!!
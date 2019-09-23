#!/bin/bash

if [[ ! -f "linkerd" ]]; then
    curl -L https://github.com/linkerd/linkerd2/releases/download/stable-2.5.0/linkerd2-cli-stable-2.5.0-linux -o linkerd
    chmod +x linkerd
fi

./linkerd install | kubectl apply -f -

./linkerd check

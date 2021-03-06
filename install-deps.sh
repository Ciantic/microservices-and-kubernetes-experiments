#!/bin/bash

# Docker is required
if [[ ! $(type -P "docker") ]]; then
    echo "You need to install docker yourself!" 1>&2
    exit 1
fi

# Install kubectl if necessary
if [[ ! $(type -P "kubectl") ]] && [[ ! -f "kubectl" ]]; then
    echo "Downloading kubectl..."
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    chmod +x kubectl
    sudo cp kubectl /bin/kubectl
fi

# Install kind if necessary
if [[ ! $(type -P "kind") ]] && [[ ! -f "kind" ]]; then
    echo "Downloading kind..."
    KIND_URL=$(curl https://api.github.com/repos/kubernetes-sigs/kind/releases \
        | grep "https://.*kind-linux-amd64\"" \
        | head -1 \
        | cut -d '"' -f 4)
    curl $KIND_URL -L -o kind
    chmod +x kind
    sudo cp kind /bin/kind
fi

# Install helm3 if necessary
if [[ ! $(type -P "helm3") ]] && [[ ! -f "helm3" ]]; then
    curl https://get.helm.sh/helm-v3.0.0-beta.3-linux-amd64.tar.gz -L -o helm3.tar.gz
    tar -xvzf helm3.tar.gz linux-amd64/helm --strip 1
    rm helm3.tar.gz
    mv helm helm3
    chmod +x helm3
    sudo cp helm3 /bin/helm3
fi

# Install helm2 if necessary
if [[ ! $(type -P "helm2") ]] && [[ ! -f "helm2" ]]; then
    curl https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz -L -o helm2.tar.gz
    tar -xvzf helm2.tar.gz linux-amd64/helm --strip 1
    rm helm2.tar.gz
    mv helm helm2
    chmod +x helm2
    sudo cp helm2 /bin/helm2
fi
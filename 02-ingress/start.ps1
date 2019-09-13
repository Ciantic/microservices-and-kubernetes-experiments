# Setup
kind create cluster --config kube-config.yaml
$env:KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

# https://github.com/helm/charts/tree/master/stable/nginx-ingress
helm install my-ingress stable/nginx-ingress --set controller.service.type=NodePort --set controller.service.nodePorts.http=30080  --set controller.service.nodePorts.https=30443

kubectl create -f service.yaml

# Wait for nginx to come online (120 seconds might not be enough)
timeout.exe 120
curl.exe http://localhost:30080/test
Pause

# Teardown
$env:KUBECONFIG=""
kind delete cluster --name kind
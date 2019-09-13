# Setup
kind create cluster --config kube-config.yaml
$env:KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

kubectl create -f service.yaml

# Alternatively using imperative calls
# kubectl run nginx --image=nginx --replicas=1
# kubectl expose deploy nginx --port=80 --target-port=80 --type=NodePort
# kubectl patch svc nginx --type=json -p '[{"op": "replace", "path": "/spec/ports/0/nodePort","value":30080}]'

# Wait for nginx to come online (50 seconds might not be enough)
timeout.exe 50
curl.exe http://localhost:30080
Pause

# Teardown
$env:KUBECONFIG=""
kind delete cluster --name kind
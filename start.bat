kubectl apply -f https://getambassador.io/yaml/ambassador/ambassador-rbac.yaml
kubectl apply -f ambassador-service.yaml
kubectl apply -f httpbin.yaml
kubectl get svc -o wide ambassador
curl localhost/httpbin/
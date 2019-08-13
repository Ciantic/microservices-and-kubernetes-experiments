cd %~dp0
rem https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-ingress-guide-nginx-example.html

echo You should see apple, banana and not found
echo -----------------------------------------------

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml
kubectl get pods --all-namespaces -l app=ingress-nginx

kubectl apply -f apple.yaml
kubectl apply -f banana.yaml
kubectl create -f ingress.yaml
timeout 3
curl -mk 10 https://localhost/apple
curl -mk 1 https://localhost/banana
curl -mk 1 https://localhost/notfound

echo -----------------------------------------------
pause
echo Cleaning...
call %~dp0\..\clean.bat
cd %~dp0
@echo off
rem https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-ingress-guide-nginx-example.html

echo "You should see apple, banana!"
echo "-----------------------------------------------"

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml
kubectl get pods --all-namespaces -l app=ingress-nginx

kubectl apply -f apple.yaml
kubectl apply -f banana.yaml
kubectl create -f ingress.yaml
timeout 22
echo "If you get an error, maybe the timeout was not long enough!"
curl.exe -km 18 https://localhost/apple
curl.exe -km 1 https://localhost/banana
REM curl.exe -sw %{http_code} -kim 1 -o /dev/null "https://localhost/notfound"

echo "-----------------------------------------------"
pause
echo "Cleaning..."
call %~dp0\..\clean.bat
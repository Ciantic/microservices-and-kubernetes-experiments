@echo off
cd %~dp0
echo You should see something
echo -----------------------------------------------

kubectl apply -f https://getambassador.io/yaml/ambassador/ambassador-rbac.yaml
kubectl apply -f ambassador-service.yaml
kubectl apply -f httpbin.yaml
kubectl get svc -o wide ambassador
timeout 3
curl -m 10 http://localhost/httpbin/

echo -----------------------------------------------
pause
echo Cleaning...
call %~dp0\..\clean.bat
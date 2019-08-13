@echo off
cd %~dp0
echo You should see It works from the Nginx
echo -----------------------------------------------

kubectl run my-nginx --image=nginx --replicas=1 --port=80 
kubectl expose deployment my-nginx --port=80 --target-port=80 --type=LoadBalancer
REM kubectl patch svc my-nginx -p '{"spec":{"externalTrafficPolicy":"Local"}}'
kubectl get svc
kubectl describe service my-nginx
timeout 3
curl -m 10 http://localhost/

echo -----------------------------------------------
pause
echo Cleaning...
call %~dp0\..\clean.bat
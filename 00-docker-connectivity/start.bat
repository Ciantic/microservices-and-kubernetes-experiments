@echo off
echo You should see It works from the Nginx
echo -----------------------------------------------

docker run -dit --rm --name nginx -p 80:80 nginx
timeout 3
curl -m 10 http://localhost/
docker stop nginx

echo -----------------------------------------------
pause
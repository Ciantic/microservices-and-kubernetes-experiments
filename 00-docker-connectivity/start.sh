#!/bin/bash

echo "Nginx example, you should see 'Welcome to nginx!' page..."

docker run -dit --rm --name nginx -p 80:80 nginx
sleep 3s
curl -m 10 http://localhost/

read -p "Press [Enter] to teardown..."
docker stop nginx
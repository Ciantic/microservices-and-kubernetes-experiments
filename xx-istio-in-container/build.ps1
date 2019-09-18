docker stop istio-build
docker build -t istio .
# -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker2
$CONTAINER_ID=$(docker run --name istio-build --rm -it -d --privileged istio)
docker exec $CONTAINER_ID docker pull alpine
docker cp dockerd.sh ${CONTAINER_ID}:/dockerd.sh
docker commit `
    $CONTAINER_ID istio2
    # -c 'ENTRYPOINT ["/dockerd.sh"]' `
	# -c 'CMD ["sh"]' `

# docker stop $CONTAINER_ID
# docker run --rm -it --privileged istio2
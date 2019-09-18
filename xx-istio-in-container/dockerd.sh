#!/bin/sh

NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
matches() {
    input="$1"
    pattern="$2"
    echo "$input" | grep -q "$pattern"
}

# Start the docker daemon in background
echo -e "${CYAN}Starting dockerd...${NOCOLOR}"
touch dockerd.log
nohup /usr/local/bin/dockerd-entrypoint.sh dockerd > /dockerd.log &

# Wait until dockerd has started (or failed)
tail -f /dockerd.log | while read -r LOGLINE
do
    echo "$LOGLINE"
    if matches "$LOGLINE" "Could not mount /sys/kernel/security"; then
        killall -s SIGINT tail
        echo -e "${RED}ERROR: Dockerd failed to start${NOCOLOR}" 1>&2
        echo "Did you forget to add --privileged to your docker call?" 
        exit 1
    fi

    if matches "$LOGLINE" "API listen on /var/run/docker.sock"; then
        echo -e "${GREEN}Dockerd started${NOCOLOR}"
        killall -s SIGINT tail
    fi
done
if [[ $? -eq 1 ]]; then
    exit 1
fi

exec "$@"
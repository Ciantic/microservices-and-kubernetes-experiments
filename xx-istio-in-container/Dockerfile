FROM docker:dind

RUN apk add wget curl

# Kubernetes in docker
RUN wget https://github.com/kubernetes-sigs/kind/releases/download/v0.5.1/kind-linux-arm64 -O /bin/kind && chmod +x /bin/kind

RUN wget https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl -O /bin/kubectl && chmod +x /bin/kubectl

COPY pulls.sh /pulls.sh
COPY dockerd.sh /dockerd.sh
COPY init.sh /init.sh

RUN chmod +x pulls.sh && chmod +x dockerd.sh

ENTRYPOINT [ "/dockerd.sh" ]
CMD [ "/init.sh" ]

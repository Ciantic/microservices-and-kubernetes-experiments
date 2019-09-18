# Kubernetes and microservice examples for Docker

These scripts should work on any Linux machine.

I have tested the script using Docker for Windows, with WSL support. If you want to do the same, ensure you have docker cli installed on your WSL and "Expose daemon on tcp" turned on from Docker for Windows.

Start each example with `start.sh`, each example is stopped before teardown for enter key.

## Dependencies

- [`Kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/) for kubernetes 
- [`kind`](https://github.com/kubernetes-sigs/kind) for testing clusters 
- [`helm` (version 3)](https://github.com/helm/helm)

If you are not scared you can install the dependencies with `install-deps.sh`, beware though it uses sudo to copy the fetched binaries to `/bin`.
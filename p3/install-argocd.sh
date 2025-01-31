#!/usr/bin/env bash

# check if efficient user id is root
if [ $(id -u) -ne 0 ]; then
    echo -e "Run as root\n\tuse command sh -"
    exit 1
fi


# delete if cluster is already present.
k3d cluster rm part-three

k3d cluster create --config ./cluster.yaml --wait
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# loop until argocd-server is up
while true; do
    echo "Waiting argo-cd to start..."
    ip=$(kubectl get endpoints argocd-server -n argocd -o jsonpath='{.subsets[*].addresses[*].ip}')
    # if ip is non zero it means that server is up
    if [ -n "$ip" ]; then
        break
    fi
    sleep 1
done

pass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)


kubectl apply -n argocd -f ./app.yaml

echo "admin password: $pass"
kubectl port-forward svc/argocd-server -n argocd 8080:443

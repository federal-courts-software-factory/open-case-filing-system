#!/bin/bash
## This file starts 
rustc --version && \
minikube start --driver=docker && \
kubectl config set-context minikube && \
kubectl config set-context --current --namespace=argocd && \
argocd login --core && \
sleep 15 && \
echo "Begin deploying argocd and pulling applications into our minikube cluster" 
git config --global --add safe.directory /workspaces/open-case-filing-system
cd /workspaces

url=https://github.com/federal-courts-software-factory/ocfs-environment.git
folder="ocfs-environment"
if [ ! -d "$FOLDER" ] ; then
    git clone "$URL" "$FOLDER"
fi
kubectl apply -k /workspaces/ocfs-environment/clusters/core/argocd/overlays/dev-cluster
# kubectl -n argocd patch secret argocd-secret \
#   -p '{"stringData": {
#     "admin.password": "$2a$10$rRyBsGSHK6.uc8fntPwVIuLVHgsAhAX7TcdrqW/RADU0uh7CaChLa",
#     "admin.passwordMtime": "'$(date +%FT%T%Z)'"
#   }}'
echo "Argocd initial admin secret is:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
# Not required without postgres and the use of sqlx (depcreated, but leaving for history)
# echo "Migrate Data into our postgres database"
# cd docket-api
# sqlx database create
# sqlx migrate run


#curl -sSf https://install.surrealdb.com | sh
#PATH=/home/vscode/.surrealdb:$PATH
#$sudo mv /home/vscode/.surrealdb/surreal /usr/local/bin
#$surreal start --log debug --user root --pass root memory
# You should install surealdb on the host until its deployable inside of a devcontainer without errors.
# docker run --rm --pull always -p 8000:8000  surrealdb/surrealdb:latest start --auth --user root --pass root file:/mydatabase.db

# 2023-08-30T15:06:34.788739Z  INFO surreal::dbs: ✅🔒 Authentication is enabled 🔒✅
# 2023-08-30T15:06:34.788821Z  INFO surrealdb::kvs::ds: Starting kvs store in file:/container-dir/mydatabase.db
# 2023-08-30T15:06:34.788859Z  INFO surrealdb::kvs::ds: Started kvs store in file:/container-dir/mydatabase.db
# 2023-08-30T15:06:34.789222Z  INFO surrealdb::kvs::ds: Initial credentials were provided and no existing root-level users were found: create the initial user 'root'.
# 2023-08-30T15:06:35.205123Z  INFO surrealdb::node: Started node agent
# 2023-08-30T15:06:35.205827Z  INFO surrealdb::net: Started web server on 0.0.0.0:8080
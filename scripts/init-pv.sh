#!/usr/bin/env sh
set -e

docker context use default
docker volume create surrealdb-data
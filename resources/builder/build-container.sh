#!/bin/sh
#update and install docker
apk add --update docker
sleep 5
dockerd > /dev/null 2>&1 &

#Build image
docker build --build-arg USER=$1 -t dev-env -f resources/Dockerfile .
docker run --name dev-env dev-env
docker export --output='output/dev-env-tar.gz' dev-env
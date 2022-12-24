#!/bin/bash
#update and install docker
apk add --update docker
sleep 5
dockerd > /dev/null 2>&1 &

#Build image
docker build --build-arg USER=$1 -d dev-env -f resources/dockerfile .
docker run --name dev-env dev-env
docker export --output='dev-env-tar.gz' dev-env
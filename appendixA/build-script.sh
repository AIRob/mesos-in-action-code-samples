#!/bin/bash
set -e

function require_env {
    if [[ -z $1 ]]; then
        echo "Error: must set $1"
        exit 1
    fi
}

require_env $DCOS_MASTER_URL
require_env $DOCKER_USERNAME
require_env $DOCKER_PASSWORD
require_env $DOCKER_EMAIL

# The Jenkins service for DCOS, at least as of version 0.1.3, defaults to
# using the java:openjdk-8-jdk Docker image, which is based on Debian Jessie.
if ! command -v jq; then
    apt-get update
    apt-get install -y jq
fi

export MARATHON_APP_ID=$(jq -r '.id' marathon.json)
export TAG=$GIT_REVISION

# There are two ways to login to Docker Hub:
#   * docker login -u <username> -p <password> -e <email>
#   * create a credentials file at ~/.docker/config.json
#
# Since using environment variables is easier to demonstrate, I'll just go
# this route for the time being.
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD -e $DOCKER_EMAIL
docker build -t myorg/demo-app:$TAG .
docker push myorg/demo-app:$TAG

# Update the Marathon application with the new image
cat marathon.json | jq ".container.docker.image |= \"${TAG}\"" > marathon.json
curl -X PUT -d @marathon.json \
    "${DCOS_MASTER_URL}/service/marathon/v2/${MARATHON_APP_ID}"

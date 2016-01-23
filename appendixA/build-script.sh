#!/bin/bash
set -e

# The Jenkins service for DCOS, at least as of version 0.1.5, defaults to
# using the mesosphere/jenkins-dind Docker image, which is based on Alpine.
if ! command -v jq > /dev/null; then
    apk --update add jq
fi

MARATHON_SVC=${MARATHON_SVC:-marathon-user}
MARATHON_APP_ID=$(jq -r '.id' marathon.json)

DOCKER_USERNAME=${DOCKER_USERNAME?"Must set \$DOCKER_USERNAME"}
DOCKER_PASSWORD=${DOCKER_PASSWORD?"Must set \$DOCKER_PASSWORD"}
DOCKER_EMAIL=${DOCKER_EMAIL?"Must set \$DOCKER_EMAIL"}

DOCKER_IMAGE=${DOCKER_IMAGE?"Must set \$DOCKER_IMAGE"}
DOCKER_TAG=${DOCKER_TAG:-${GIT_COMMIT:-latest}}

# There are two ways to login to Docker Hub:
#   * docker login -u <username> -p <password> -e <email>
#   * create a credentials file at ~/.docker/config.json
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD -e $DOCKER_EMAIL
docker build -t "${DOCKER_IMAGE}:${DOCKER_TAG}" .
docker push "${DOCKER_IMAGE}:${DOCKER_TAG}"

# Update the Marathon application with the new tag
cat marathon.json \
    | jq ".container.docker.image |= \"${DOCKER_IMAGE}:${DOCKER_TAG}\"" \
    > marathon.json

curl -X PUT -d @marathon.json \
    "http://leader.mesos/service/${MARATHON_SVC}/v2/apps/${MARATHON_APP_ID}"

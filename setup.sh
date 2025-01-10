#!/bin/bash

set -e

# Enable Docker BuildKit
export DOCKER_BUILDKIT=1

# Get user and group information
USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER_NAME=${USER}

# Set defaults for name, Dockerfile, and entrypoint
CONTAINER_NAME=${1:-"workenv"}
DOCKERFILE_PATH=${2:-"Dockerfile"}
DEFAULT_ENTRYPOINT=${3:-"/bin/bash"}

# Build the Docker image
docker build \
    --build-arg UID=${USER_ID} \
    --build-arg GID=${GROUP_ID} \
    --build-arg USR=${USER_NAME} \
    -t ${CONTAINER_NAME} \
    -f ${DOCKERFILE_PATH} .

# Run the Docker container
docker run \
    -v ~/:/home/${USER_NAME} \
    -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    --cap-add=SYS_PTRACE \
    -it ${CONTAINER_NAME} \
    ${DEFAULT_ENTRYPOINT}
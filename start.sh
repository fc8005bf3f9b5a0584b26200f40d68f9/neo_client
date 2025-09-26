#!/bin/bash -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
COMMAND="$*"

#if [[ -z "${VERSION}" && -f "${DIR}/.version" ]]; then
#  VERSION=$(xargs <"${DIR}/.version")
#fi

#if [[ -z "${VERSION}" ]]; then
#  VERSION=latest
#fi

#IMAGE="ghcr.io/pomo-mondreganto/neo_env:${VERSION}"
#CONTAINER_NAME="neo-${VERSION}"

echo "Building image..."
TAG=$(docker build --platform linux/amd64 -t neo_client_mod .)

echo "Using image: neo_client_mod"
OUT=$(docker ps --filter "name=neo_client_mod" --format "{{ .Names }}")

if [[ $OUT ]]; then
  echo "Container already exists"
  # shellcheck disable=SC2068
  docker exec -it "neo_client_mod" ${COMMAND[@]}
else
  echo "Starting a new container"
  docker run -it \
    --rm \
    --volume "${DIR}":/work \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    --cap-add=NET_ADMIN \
    --privileged \
    --platform=linux/amd64 \
    --name "neo_client_mod" \
    --hostname "neo_client_mod" \
    "neo_client_mod" \
    "${COMMAND}"
fi

#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(readlink -f "$0" | xargs dirname)
readonly SCRIPT_DIR
readonly STACKNAME="sysadmin-nodrama"
readonly UBUNTU_CONTAINER="${STACKNAME}-ubuntu"

docker_compose_up() {
    docker compose \
        -f "${SCRIPT_DIR}/docker-compose.yml" \
        -p $STACKNAME \
        up \
        --detach \
        --build
}

connect_container() {
    local container_name="$UBUNTU_CONTAINER"
    local container_shell="/bin/bash"
    docker exec -it "$container_name" "$container_shell"
}

main() {
    docker_compose_up
    connect_container
}

main "$@"
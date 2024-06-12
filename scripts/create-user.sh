#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(readlink -f "$0" | xargs dirname)
readonly SCRIPT_DIR

add_user() {
    local username="$1"
    useradd \
        --create-home \
        --shell /bin/bash \
        "$username"
}

make_user_sudoer() {
    local username="$1"
    usermod -aG sudo "$username"
    echo "${username} ALL=(ALL) NOPASSWD: ALL" \
        | sudo tee "/etc/sudoers.d/${username}"
}

link_user_to_groups() {
    local username="$1"
    local groups="$2"
    usermod -aG "$groups" "$username"
}

copy_user_ssh_public_key() {
    local username="$1"
    local ssh_public_key="$2"
    local user_id; user_id="$(id -u "${username}")"
    local group_id; group_id="$(id -g "${username}")"

    mkdir -p "/home/${username}/.ssh"
    install -m 644 /dev/null "/home/${username}/.ssh/authorized_keys"
    chown "${user_id}:${group_id}" "/home/${username}/.ssh"
    chown "${user_id}:${group_id}" "/home/${username}/.ssh/authorized_keys"

    echo "$ssh_public_key" >> "/home/${username}/.ssh/authorized_keys"
}

main() {
    local username="$1"
    local groups="$2"
    local ssh_public_key="$3"

    add_user "$username"
    make_user_sudoer "$username"
    link_user_to_groups "$username" "$groups"
    copy_user_ssh_public_key "$username" "$ssh_public_key"
}

main "$@"
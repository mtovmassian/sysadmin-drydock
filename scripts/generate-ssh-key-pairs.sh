#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(readlink -f "$0" | xargs dirname)"
readonly SCRIPT_DIR

usage() {
    script_name="$(basename "$0")"
    cat << EOF
Usage: ./$script_name [FIRSTNAME,LASTNAME]...

Generate SSH key pair for one or more users.

Example:
    ./$script_name alice,smith bob,johnson
EOF
}

main() {

    set +u
    [[ -z "$1" ]] && usage && exit 1
    [[ "$1" == "-h" || "$1" == "--help" ]] && usage && exit 0
    set -u

    local today_date; today_date="$(date +%Y%m%d)"
    for arg in "$@"; do
        echo "$arg" | { 
            IFS="," read -r first_name last_name
            local key_name="${first_name}_${last_name}_rsa_${today_date}"
            local key_file="${SCRIPT_DIR}/${key_name}"
            local key_comment="$key_name"
            ssh-keygen \
                -t rsa \
                -b 3072 \
                -f "$key_file" \
                -q \
                -N "" \
                -C "$key_comment"
        }
    done
}

main "$@"
#!/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$0")/.."

if [[ "${HALBERD_TEST_VM:-}" != "YES" ]]; then
    echo "Test VM confirmation required."
    exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
    echo "This script must be run with administrative privileges (as root or with sudo)."
    exit 1
fi

create_user() {
    local first_name = "$1"
    local last_name = "$2"
    local username
    local password

    username = "${first_name,,}.${last_name,,}"
    password = "${first_name,,}${last_name,,}HALBERD"

    if id "$username" $>/dev/null; then
        echo "User $username already exists. Skipping."
        return
    fi

    if useradd -m -s /bin/bash "$username"; then
        if echo "$username:$password" | chpasswd; then
            echo "User $username created successfully."
        else
            echo "Failed to set password for $username."1
            userdel -r "$username"
        fi
    else
        echo "Failed to create user $username."
    fi
}

automatic_user_creation() {
    FACULTY_FILE="data/facult_names.txt"

    if [[ ! -f "$FACULTY_FILE" ]]; then
        echo "Faculty file not found."
        exit 1
    fi

    while IFS= read -r first_name last_name; do
        create_user "$first_name" "$last_name"
    done < "$FACULTY_FILE"

    echo "User creation process completed."
}

manual_user_creation() {
    read -r -p "Enter first name: " first_name
    read -r -p "Enter last name: " last_name
    create_user "$first_name" "$last_name"
}
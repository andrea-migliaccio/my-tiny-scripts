#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${1:-}"
TARGET_DIR="${2:-}"

if [[ -z "$REPO_URL" ]]; then
    echo "Usage: gitlab-clone.sh <gitlab-repo-url> [target-dir]"
    exit 1
fi

if [[ -z "${GITLAB_USER:-}" ]]; then
    echo "Errore: variabile d'ambiente GITLAB_USER non impostata"
    exit 1
fi

if [[ -z "${GITLAB_PAT:-}" ]]; then
    echo "Errore: variabile d'ambiente GITLAB_PAT non impostata"
    exit 1
fi

urlencode() {
    local raw="$1"
    local length="${#raw}"
    local encoded=""
    local char
    local i

    for ((i = 0; i < length; i++)); do
        char="${raw:i:1}"
        case "$char" in
            [a-zA-Z0-9.~_-]) encoded+="$char" ;;
            *) encoded+=$(printf '%%%02X' "'$char") ;;
        esac
    done

    printf '%s' "$encoded"
}

if [[ "$REPO_URL" != http://* && "$REPO_URL" != https://* ]]; then
    echo "Errore: l'URL deve iniziare con http:// o https://"
    exit 1
fi

URL_NO_SCHEME="${REPO_URL#http://}"
URL_NO_SCHEME="${URL_NO_SCHEME#https://}"
URL_NO_AUTH="${URL_NO_SCHEME#*@}"

ENC_USER="$(urlencode "$GITLAB_USER")"
ENC_PASS="$(urlencode "$GITLAB_PAT")"
AUTH_URL="https://${ENC_USER}:${ENC_PASS}@${URL_NO_AUTH}"

if [[ -n "$TARGET_DIR" ]]; then
    exec git clone "$AUTH_URL" "$TARGET_DIR"
fi

exec git clone "$AUTH_URL"

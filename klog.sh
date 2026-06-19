#!/usr/bin/env bash

set -euo pipefail

FOLLOW=""

if [[ "${1:-}" == "-f" ]]; then
    FOLLOW="-f"
    shift
fi

SEARCH="${1:-}"

if [[ -z "$SEARCH" ]]; then
    echo "Usage: klog [-f] <pod-name-fragment>"
    exit 1
fi

mapfile -t PODS < <(
    kubectl get pods --no-headers -o custom-columns=":metadata.name" |
    grep "$SEARCH" || true
)

COUNT=${#PODS[@]}

if [[ $COUNT -eq 0 ]]; then
    echo "Nessun pod trovato che contiene '$SEARCH'"
    exit 1
fi

if [[ $COUNT -eq 1 ]]; then
    POD="${PODS[0]}"
else
    POD=$(
        printf '%s\n' "${PODS[@]}" |
        fzf \
            --height=40% \
            --reverse \
            --prompt="Select pod > "
    )

    [[ -z "$POD" ]] && exit 1
fi

echo "Opening logs for $POD"
exec kubectl logs $FOLLOW "$POD"



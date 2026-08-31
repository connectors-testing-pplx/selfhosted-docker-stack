#!/usr/bin/env bash
# scripts/up.sh — start the stack and ensure acme.json permissions.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

ACME=traefik/acme.json
if [[ ! -f "${ACME}" ]]; then
  cp traefik/acme.json.placeholder "${ACME}"
fi
chmod 600 "${ACME}"

docker compose up -d
docker compose ps

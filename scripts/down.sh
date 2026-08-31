#!/usr/bin/env bash
# scripts/down.sh — stop the stack, preserving data volumes.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
docker compose down

#!/usr/bin/env bash
# scripts/backup-volumes.sh — dump all named volumes to a tar.gz.
# Usage: backup-volumes.sh <dest_dir>
set -euo pipefail
DEST="${1:-./backups}"
mkdir -p "${DEST}"
stamp="$(date +%Y%m%d-%H%M%S)"
out="${DEST}/volumes-${stamp}.tar.gz"

cd "$(dirname "${BASH_SOURCE[0]}")/.."
mapfile -t VOLUMES < <(docker volume ls -q)

for v in "${VOLUMES[@]}"; do
  echo "Backing up volume ${v} ..."
  docker run --rm -v "${v}:/data:ro" -v "${PWD}/${DEST}:/backup" alpine \
    tar -czf "/backup/${v}-${stamp}.tar.gz" -C /data .
done

echo "Volumes backed up to ${DEST}/"

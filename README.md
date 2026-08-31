# selfhosted-docker-stack

A turnkey, self-hosted services stack deployed with Docker Compose. Fronted by Traefik for automatic TLS and reverse proxy routing, with a curated set of open-source apps — ideal for a homelab or small-team internal platform.

## What it does

- **Reverse proxy + TLS** — Traefik with Let's Encrypt (or self-signed) certificates and automatic routing via Docker labels
- **Dashboard** — Heimdall as a launchpad for all services
- **Notes/Wiki** — Joplin server for shared knowledge
- **File sync** — Nextcloud (with MariaDB) for document storage and sharing
- **Passwords** — Vaultwarden (Bitwarden-compatible) with secure secrets
- **Media** — Jellyfin for media streaming
- **Maintenance** — Watchtower for automatic image updates, with a backup sidecar

## Repository layout

```
selfhosted-docker-stack/
├── docker-compose.yml
├── .env.example
├── traefik/
│   ├── traefik.yml
│   ├── dynamic/
│   │   └── tls.yml
│   └── acme.json.placeholder       # chmod 600 on real file
├── nextcloud/
│   └── init-db.sql
├── scripts/
│   ├── up.sh
│   ├── down.sh
│   └── backup-volumes.sh
└── README.md
```

## Quick start

```bash
cp .env.example .env
# edit .env: set DOMAIN, EMAIL, passwords
docker compose up -d
```

## Service routing

Traefik routes by hostname based on `DOMAIN`. With `DOMAIN=home.lan`:

| Service     | URL                          |
|-------------|------------------------------|
| Traefik UI  | https://traefik.home.lan     |
| Dashboard   | https://dash.home.lan        |
| Nextcloud   | https://cloud.home.lan       |
| Vaultwarden | https://vault.home.lan       |
| Jellyfin    | https://media.home.lan       |
| Joplin      | https://notes.home.lan       |

## Operations

```bash
# Start the full stack
./scripts/up.sh

# Stop everything (keeps data)
./scripts/down.sh

# Back up all named volumes to a tar.gz
./scripts/backup-volumes.sh /mnt/backup
```

## Security notes

- All persistent data lives in named Docker volumes — never bind-mounted into the repo.
- `acme.json` must be `chmod 600`; the placeholder is replaced on first run.
- Vaultwarden requires HTTPS — Traefik provides it via the configured challenge.
- Watchtower is set to a dry-run-safe schedule and pinned to a notification webhook.

## Prerequisites

- Docker 24+ and Docker Compose v2
- A DNS record (or local hosts/`dnsmasq`) resolving `*.${DOMAIN}` to the host
- Ports 80 and 443 reachable on the host

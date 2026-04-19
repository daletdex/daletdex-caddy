#!/bin/sh
set -eu

DOMAIN="${DOMAIN:?DOMAIN is required (public hostname, e.g. app.example.com)}"

mkdir -p /data /config/caddy

# Caddy obtiene certificados vía ACME; 80/443 los publica el stack Swarm.
cat >/etc/caddy/Caddyfile <<EOF
${DOMAIN} {
    encode zstd gzip
    reverse_proxy daletdex-frontend:80
}
EOF

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile

#!/usr/bin/env bash

# ==========================================================
# Nginx Virtual Host Auto Setup
# Author: Ushan Perera
# Description:
# Automates Nginx server block creation for Linux servers
# ==========================================================

set -euo pipefail

DOMAIN="${1:-}"
WEB_ROOT_BASE="${2:-/var/www}"
NGINX_SITES_AVAILABLE="${3:-/etc/nginx/sites-available}"
NGINX_SITES_ENABLED="${4:-/etc/nginx/sites-enabled}"
NGINX_USER="${5:-www-data}"

line() {
    printf '%*s\n' "${COLUMNS:-70}" '' | tr ' ' '='
}

section() {
    echo
    line
    echo "$1"
    line
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

if [[ -z "$DOMAIN" ]]; then
    echo "Usage: $0 <domain> [web_root_base] [sites_available] [sites_enabled] [nginx_user]"
    exit 1
fi

WEB_ROOT="${WEB_ROOT_BASE}/${DOMAIN}"
NGINX_CONFIG="${NGINX_SITES_AVAILABLE}/${DOMAIN}"

section "NGINX VHOST AUTO SETUP"
log "Domain             : ${DOMAIN}"
log "Web root           : ${WEB_ROOT}"
log "Sites available    : ${NGINX_SITES_AVAILABLE}"
log "Sites enabled      : ${NGINX_SITES_ENABLED}"
log "Nginx user         : ${NGINX_USER}"

section "CREATING WEB ROOT"
mkdir -p "${WEB_ROOT}/public_html"
mkdir -p "${WEB_ROOT}/logs"

cat > "${WEB_ROOT}/public_html/index.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${DOMAIN}</title>
</head>
<body>
    <h1>${DOMAIN} is live</h1>
    <p>Nginx virtual host created successfully.</p>
</body>
</html>
EOF

chown -R "${NGINX_USER}:${NGINX_USER}" "${WEB_ROOT}"
chmod -R 755 "${WEB_ROOT}"

section "CREATING NGINX SERVER BLOCK"

cat > "${NGINX_CONFIG}" <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name ${DOMAIN} www.${DOMAIN};

    root ${WEB_ROOT}/public_html;
    index index.html index.htm index.php;

    access_log ${WEB_ROOT}/logs/access.log;
    error_log ${WEB_ROOT}/logs/error.log;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

section "ENABLING SITE"
ln -sf "${NGINX_CONFIG}" "${NGINX_SITES_ENABLED}/${DOMAIN}"

section "TESTING NGINX CONFIGURATION"
nginx -t

section "RELOADING NGINX"
if command -v systemctl >/dev/null 2>&1; then
    systemctl reload nginx
else
    service nginx reload
fi

section "SETUP COMPLETE"
log "Virtual host created successfully for ${DOMAIN}"
echo "Document root : ${WEB_ROOT}/public_html"
echo "Config file   : ${NGINX_CONFIG}"

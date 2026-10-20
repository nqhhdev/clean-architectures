#!/bin/sh
# Container entrypoint (ADR 0018). Reads the environment, fails fast on an invalid value, then writes:
#   env.js                 the runtime config the SPA parses at boot (public values only, ADR 0009)
#   security-headers.conf  CSP and the other security headers; connect-src is generated from API_URL
#   nginx server config    includes the headers file in every location that sets headers of its own
# and starts the command it was given (nginx). The same rule as src/app/runtime-config.ts decides what API_URL may be;
# both are covered by tests (docker/entrypoint.test.mjs, src/app/runtime-config.test.ts).
#
# Variables: API_URL (required: https URL, https-or-local http URL, or a same-origin path such as /api).
# Output locations can be overridden for tests: RUNTIME_DIR, NGINX_CONF_PATH, WEB_ROOT.
set -eu

RUNTIME_DIR="${RUNTIME_DIR:-/tmp/runtime}"
NGINX_CONF_PATH="${NGINX_CONF_PATH:-/etc/nginx/conf.d/default.conf}"
WEB_ROOT="${WEB_ROOT:-/usr/share/nginx/html}"

fail() {
  echo "entrypoint: $1" >&2
  exit 1
}

API_URL="${API_URL:-}"
[ -n "$API_URL" ] || fail "API_URL is required"

PATH_CHARS='[A-Za-z0-9._~/-]*'
HOST_CHARS='[A-Za-z0-9.-]+'
PORT='(:[0-9]{1,5})?'

# Strip trailing slashes, as the SPA does.
API_URL=$(printf '%s' "$API_URL" | sed -E 's#/+$##')

if printf '%s' "$API_URL" | grep -Eq "^/($PATH_CHARS)?\$" && ! printf '%s' "$API_URL" | grep -Eq '^//'; then
  CONNECT_SRC="'self'"
elif printf '%s' "$API_URL" | grep -Eq "^https?://($HOST_CHARS|\\[::1\\])$PORT(/$PATH_CHARS)?\$"; then
  scheme=$(printf '%s' "$API_URL" | sed -E 's#^(https?)://.*#\1#')
  origin=$(printf '%s' "$API_URL" | sed -E 's#^(https?://[^/]+).*#\1#')
  host=$(printf '%s' "$origin" | sed -E 's#^https?://##; s#:[0-9]+$##')
  if [ "$scheme" = "http" ]; then
    case "$host" in
      localhost | 127.0.0.1 | '[::1]' | *.localhost) ;;
      *) fail "API_URL must use https unless the host is local" ;;
    esac
  fi
  CONNECT_SRC="'self' $origin"
else
  fail "API_URL must be an absolute http(s) URL without credentials, query or fragment, or a path starting with /"
fi

mkdir -p "$RUNTIME_DIR"

# API_URL only holds characters from the patterns above, so it is safe inside a JS string, a CSP and an nginx string.
printf 'window.__ENV__ = Object.freeze({"API_URL":"%s"});\n' "$API_URL" >"$RUNTIME_DIR/env.js"

CSP="default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self'; connect-src $CONNECT_SRC; object-src 'none'; base-uri 'self'; form-action 'self'; frame-ancestors 'none'"
HEADERS="$RUNTIME_DIR/security-headers.conf"
cat >"$HEADERS" <<EOF
add_header Content-Security-Policy "$CSP" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "DENY" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
add_header Cross-Origin-Opener-Policy "same-origin" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
EOF

# An add_header in a location replaces the inherited ones, so each such location includes the headers file again.
cat >"$NGINX_CONF_PATH" <<EOF
server_tokens off;

server {
  listen 8080;
  server_name _;
  root $WEB_ROOT;
  index index.html;
  gzip on;
  gzip_static on;
  gzip_vary on;
  gzip_types text/css application/javascript application/json image/svg+xml;
  include $HEADERS;

  location = /env.js {
    alias $RUNTIME_DIR/env.js;
    add_header Cache-Control "no-store" always;
    include $HEADERS;
  }

  location /assets/ {
    try_files \$uri =404;
    add_header Cache-Control "public, max-age=31536000, immutable" always;
    include $HEADERS;
  }

  location = /healthz {
    access_log off;
    default_type text/plain;
    return 200 "ok\n";
  }

  location / {
    try_files \$uri /index.html;
    add_header Cache-Control "no-cache" always;
    include $HEADERS;
  }
}
EOF

if [ "$#" -gt 0 ]; then
  exec "$@"
fi

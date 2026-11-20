#!/bin/sh
# Gateway start (Railway): validates the sign-in variables, hashes the password
# (Caddy needs bcrypt) and runs Caddy. No deploy-form value stops the deploy:
# a missing or unusable password locks the site instead of opening it.
set -u

log() { echo "[railway-gateway] $*"; }
warn() { echo "[railway-gateway] WARNING: $*" >&2; }

port="${PORT:-8080}"
case "$port" in
'' | *[!0-9]*) warn "PORT='$port' is not a port number; using 8080"; port=8080 ;;
esac
PORT=$port

user=${BOLT_USERNAME:-}
case "$user" in
'' | *[!A-Za-z0-9._@-]*)
	warn "BOLT_USERNAME='$user' is empty or has characters other than A-Z a-z 0-9 . _ @ -; using 'bolt'"
	user=bolt
	;;
esac
[ "${#user}" -le 64 ] || { warn "BOLT_USERNAME is longer than 64 characters; using 'bolt'"; user=bolt; }

password=${BOLT_PASSWORD:-}
if [ "${#password}" -lt 12 ] || [ "${#password}" -gt 72 ]; then
	# bcrypt uses at most 72 bytes; shorter than 12 is too easy to guess.
	password=$(od -An -N24 -tx1 /dev/urandom | tr -d ' \n')
	warn "BOLT_PASSWORD is empty, shorter than 12 or longer than 72 characters."
	warn "The site is LOCKED with a random password nobody knows. Set BOLT_PASSWORD"
	warn "(12-72 characters) on the bolt.diy service and redeploy it to sign in."
fi

upstream=${BOLT_UPSTREAM:-}
if [ -z "$upstream" ]; then
	warn "BOLT_UPSTREAM is empty; using bolt.railway.internal:5173"
	upstream=bolt.railway.internal:5173
fi

BASIC_AUTH_HASH=$(caddy hash-password --plaintext "$password") || {
	warn "caddy hash-password failed; locking the site with a random password"
	BASIC_AUTH_HASH=$(caddy hash-password --plaintext "$(od -An -N24 -tx1 /dev/urandom | tr -d ' \n')")
}
unset BOLT_PASSWORD password
BASIC_AUTH_USERNAME=$user
BOLT_UPSTREAM=$upstream
export PORT BASIC_AUTH_USERNAME BASIC_AUTH_HASH BOLT_UPSTREAM

log "basic auth for user $BASIC_AUTH_USERNAME; bolt.diy at $BOLT_UPSTREAM; port $PORT"
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile

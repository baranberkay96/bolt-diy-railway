# bolt.diy gateway: basic-auth reverse proxy in front of bolt.diy.
# The official Caddy image, pinned by tag and digest.
FROM caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0

# /etc/caddy and /usr/local/bin exist in the base image.
COPY Caddyfile /etc/caddy/Caddyfile
COPY --chmod=0755 railway-gateway.sh /usr/local/bin/railway-gateway.sh

# Fail the build rather than the deploy on a Caddyfile error.
RUN sh -n /usr/local/bin/railway-gateway.sh \
 && PORT=8080 BASIC_AUTH_USERNAME=check \
    BASIC_AUTH_HASH='$2a$14$abcdefghijklmnopqrstuuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0' \
    BOLT_UPSTREAM=bolt.railway.internal:5173 \
    caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-gateway.sh"]
CMD []

# NOTICE: bolt.diy v1 AI Web App Builder (Password-Protected) template

## Software deployed

- **bolt.diy** by StackBlitz Labs and contributors, MIT License, https://github.com/stackblitz-labs/bolt.diy. Deployed unmodified from the official image `ghcr.io/stackblitz-labs/bolt.diy:v1.0.3` (pinned by digest).
- **Caddy** 2.11.9, Apache License 2.0, https://github.com/caddyserver/caddy, official image `caddy:2.11.9-alpine` (pinned by digest).
- WebContainers (used by bolt.diy in the browser) are a StackBlitz service with their own terms: https://webcontainers.io

## Written for this template

- `services/gateway/*`: Caddy configuration and start script (basic auth, cross-site refusal, fail-closed password handling), adapted from our own Bytebot template gateway.
- `README.md`, `TEMPLATE.md`, `template.json`.

## Upstream files checked (read only, 2026-11-20)

- `Dockerfile`, `docker-compose.yaml`, `package.json`, `vite.config.ts`, `wrangler.jsonc`, `workers/app.ts`, `app/routes/api.check-env-key.ts`, `app/lib/modules/llm/base-provider.ts` and the provider modules at tag `v1.0.3`.
- `@cloudflare/vite-plugin` 1.63.0 (`dist/index.mjs`): preview-mode variables (`.dev.vars`, `CLOUDFLARE_INCLUDE_PROCESS_ENV`).

## Market templates reviewed

`C--NRV`, `YaqTB9`, `abVHie` (configuration only; nothing copied).

## Names and affiliation

bolt.diy and Bolt.new are projects of StackBlitz. This is a community template, not affiliated with or endorsed by StackBlitz. The icon is bolt.diy's own favicon.

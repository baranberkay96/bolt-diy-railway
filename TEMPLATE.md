# bolt.diy v1 AI Web App Builder (Password-Protected): Railway template spec

## Listing

| Field | Value |
|---|---|
| Name | **bolt.diy v1 AI Web App Builder (Password-Protected)** (major version of the pinned v1.0.3) |
| Description | Prompt, run and edit full-stack apps in the browser with any LLM. (65 chars) |
| Category | AI/ML |
| Tags | bolt.diy, bolt, ai-coding, app-builder, webcontainers, llm, openai, anthropic, openrouter, vibe-coding |
| Icon | bolt.diy's `public/favicon.svg` via jsDelivr at a pinned commit |
| Repo | `baranberkay96/bolt-diy-railway`, gateway root `/services/gateway` |

## Feasibility (checked 2026-11-20)

- Licence: MIT. WebContainers are a StackBlitz browser service with their own terms (NOTICE).
- No Docker-in-Docker: generated projects run in a WebContainer in the user's browser; the server only proxies LLM calls.
- bolt.diy has no sign-in and server-side keys are used for every visitor, so a password gateway is required.

## Base market templates (checked 2026-11-20)

- `C--NRV` "bolt.diy" (197 active): `ghcr.io/stackblitz-labs/bolt.diy` unpinned, public, no auth.
- `YaqTB9` "Bolt.DIY" (139 active): repo build, public, no auth.
- `abVHie` "Bolt.diy NEW" (122 active): commit-tag image, public, no auth.

### Improvements over market templates

1. Password gateway (Caddy basic auth, fail-closed, cross-site requests refused); the app is private-network only.
2. Release image pinned by tag and index digest.
3. Optional provider keys under the names bolt.diy reads, passed to the worker runtime (`CLOUDFLARE_INCLUDE_PROCESS_ENV=true`).

## Pinned versions

| Component | Reference | Checked |
|---|---|---|
| bolt.diy | `ghcr.io/stackblitz-labs/bolt.diy:v1.0.3@sha256:89f1061e2ffad4f51125c6f931f18a4b2aaec2a1010799ea6b9608f399d7c99e` | 2026-11-20 |
| Caddy | `caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0` | 2026-11-20 |

## Architecture

```
Browser ──https──► bolt.diy (Caddy :8080, basic auth) ──private──► bolt (vite preview :5173)
                                                                     └─► LLM provider APIs
Generated projects run in a WebContainer in the browser; chats live in browser IndexedDB.
```

## Services and variables

| Service | Source | Health | Domain | Volume |
|---|---|---|---|---|
| bolt.diy | repo `/services/gateway` | `/_gateway/health` | public, 8080 | – |
| bolt | image (pinned), `pnpm run start` | none (see below) | private, 5173 | – |

Gateway: `BOLT_USERNAME=bolt`, `BOLT_PASSWORD` (`secret(24)`), `PORT=8080`, `BOLT_UPSTREAM=${{bolt.RAILWAY_PRIVATE_DOMAIN}}:5173`.
bolt: `PORT=5173`, `NODE_ENV=production`, `CLOUDFLARE_INCLUDE_PROCESS_ENV=true`, optional provider keys.

**No healthcheck on `bolt`.** Railway's healthcheck to `/` failed on every attempt (also with `__VITE_ADDITIONAL_SERVER_ALLOWED_HOSTS=healthcheck.railway.app`), while the same `/` through the gateway answers 200 in 0.3 s. The service is private and the gateway retries the upstream for 30 s (`lb_try_duration`), so the gateway's healthcheck is the one that matters.

## Resource profile (measured on Railway, 2026-11-20)

| Service | Idle RAM | CPU idle |
|---|---|---|
| bolt | 0.63 GB | ~0.005 vCPU |
| bolt.diy (gateway) | 0.02–0.04 GB | ~0.01 vCPU |

Estimated idle cost ≈ 0.67 GB × $10 ≈ **$7/month**. Minimum plan: Hobby (fits Trial's 1 GB but with little headroom).

## Test results (Railway, pre-publish, 2026-11-20)

- Both services SUCCESS (bolt without healthcheck, gateway healthcheck 200).
- `/` without credentials → 401; with the generated credentials → 200 HTML, all 46 `/assets/*` files load, `Cross-Origin-Embedder-Policy: credentialless` present (needed by WebContainers).
- `/api/models` → full provider model list; `/api/check-env-key?provider=OpenAI` → `{"isSet":false}` with no key set.
- 8.29: `BOLT_PASSWORD=short` → gateway SUCCESS, log "The site is LOCKED…", sign-in with `short` → 401, health 200. Restored afterwards.

## Verification checklist

- `https://{domain}/_gateway/health` → `ok`.
- `/` asks for a password; sign in with `BOLT_USERNAME`/`BOLT_PASSWORD`.
- Choose a provider, paste a key, prompt "a todo app in React"; the preview starts in the browser.

## Open questions

- A full generation with a real LLM key was not run (no key in the test workspace).
- WebContainers need a Chromium-based browser; Firefox/Safari support is limited (README says so).

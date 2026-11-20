# Deploy and Host bolt.diy with Railway

bolt.diy is the open-source version of Bolt.new: describe an app in a prompt and an AI model writes, runs and edits a full-stack web project right in your browser. This community template runs the bolt.diy 1.0 release on Railway behind a password, so only you can use it and the LLM keys you configure.

## About Hosting bolt.diy

bolt.diy is a React Router app served by Vite's Cloudflare preview server. The server side forwards prompts to the LLM provider you choose (OpenAI, Anthropic, Gemini, OpenRouter, DeepSeek, Groq, Mistral, xAI, Ollama, any OpenAI-compatible endpoint and more). The generated project runs in a WebContainer inside your own browser tab, so installing packages and starting dev servers costs no server resources.

bolt.diy has no sign-in of its own, and keys set on the server are used for every visitor. That is why this template puts a small Caddy gateway with a generated password in front of it; the app itself runs on Railway's private network only. Chats and projects are stored in your browser (IndexedDB), so the server keeps no data and needs no database or volume.

## Common Use Cases

- Prototype web apps, landing pages and dashboards from a prompt
- Try the same app idea with different LLMs side by side
- Edit generated code in the built-in editor and terminal, then export a ZIP or push to GitHub
- Deploy generated sites to Netlify or Vercel from the UI
- Run a private Bolt-style builder for a small team on your own keys

## Dependencies for bolt.diy Hosting

- An LLM provider key (entered in the UI or set as a Railway variable), or an Ollama / OpenAI-compatible server
- A Chromium-based browser for WebContainers (Chrome, Edge, Brave); Firefox and Safari have limited support

### Deployment Dependencies

- bolt.diy source: https://github.com/stackblitz-labs/bolt.diy
- bolt.diy docs: https://stackblitz-labs.github.io/bolt.diy/
- Caddy: https://caddyserver.com/docs/
- Template source: https://github.com/baranberkay96/bolt-diy-railway

### Implementation Details

| Service | What it runs | Public | Volume |
|---|---|---|---|
| bolt.diy | Caddy 2.11 gateway with basic auth | yes, port 8080 | – |
| bolt | `ghcr.io/stackblitz-labs/bolt.diy:v1.0.3` (pinned by digest), `vite preview` | private, 5173 | – |

**First login.** Open the public URL of the bolt.diy service and sign in with `BOLT_USERNAME` and `BOLT_PASSWORD` (generated at deploy, in the service's Variables tab). Pick a provider and model in the chat box. Either paste your key in the UI (stored in a cookie in your browser) or set it on the `bolt` service before deploying: `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GOOGLE_GENERATIVE_AI_API_KEY`, `OPEN_ROUTER_API_KEY`, `DEEPSEEK_API_KEY`, `XAI_API_KEY`, `GROQ_API_KEY`, `MISTRAL_API_KEY`, `OLLAMA_API_BASE_URL`, `OPENAI_LIKE_API_BASE_URL` + `OPENAI_LIKE_API_KEY`. Keys set on Railway are used for everyone who signs in.

**Security.** The gateway refuses cross-site requests (browsers would otherwise send the cached password with them). An empty, too short or too long password never opens the site: the start log says it is locked and how to fix it.

**Resources.** The gateway uses about 20 MB. The bolt service has no data to keep; its memory use was not measured yet.

**Scaling.** The `bolt` service is stateless; give it more CPU or memory if many people use it at once. Generated projects run in each user's browser, not on Railway.

**Upgrading.** The image is pinned by tag and digest in the `bolt` service's source. To upgrade, set a newer release tag from `ghcr.io/stackblitz-labs/bolt.diy` and redeploy.

### Why Deploy bolt.diy on Railway?

Railway runs bolt.diy with HTTPS, a private network and a generated password in one click, so you get your own AI app builder on your own keys without exposing them to the internet. There is nothing to maintain on the server: no database, no volume, and usage-based pricing for a mostly idle service.

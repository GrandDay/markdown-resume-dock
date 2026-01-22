# Markdown Resume

Write an ATS-friendly Resume in Markdown. Available for anyone, Optimized for Dev.

![Markdown Resume screenshot](https://raw.githubusercontent.com/junian/markdown-resume/assets/img/markdown-resume-screenshot-00.jpg)

## About

A fork of "Markdown-Resume". See the original work: [junian/markdown-resume](https://github.com/junian/markdown-resume).
Markdown-Resume is in turn a fork of "Oh My CV!": [ohmycv.app](https://ohmycv.app).



## Why This Fork?

This edition is tuned for self-hosting with Docker (and Dokploy) instead of GitHub Pages. It adds:

- ✅ Dockerfile + Nginx SPA routing (client routes work on refresh)
- ✅ Optional env vars for custom domains / subpaths
- ✅ Dokploy-friendly deploy flow
- ✅ README docs for self-hosting

## Quick Start (Docker)

The image builds to a static site and serves with Nginx. Defaults work with **zero config**.

```bash
# defaults: base=/ , site url=http://localhost:3000 , name="Markdown Resume"
docker build -t markdown-resume .
docker run -d -p 80:80 markdown-resume

# optional: set your domain or subpath
docker build -t markdown-resume \
  --build-arg NUXT_PUBLIC_SITE_URL=https://resume.example.com \
  --build-arg NUXT_PUBLIC_BASE_URL=/ \
  --build-arg NUXT_PUBLIC_SITE_NAME="Your Name" .
```

## Dokploy Deployment

Point Dokploy to the repo, choose **Dockerfile** build, and deploy. Leave build args empty for a root-domain deploy; set `NUXT_PUBLIC_BASE_URL=/resume/` only if you serve under a sub-path. Refer to [.env.example](.env.example) for optional public settings.

## **The Rest Below is from Markdown Resume**

## Notice

Highly recommend using Chromium-based browsers, e.g., [Chrome](https://www.google.com/chrome/) and [Microsoft Edge](https://www.microsoft.com/en-us/edge).

## Features

- Write your resume in Markdown and preview it in real-time, it's smooth!
- It works offline ([PWA](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps))
- Export to A4 and US Letter size PDFs
- Customize page margins, theme colors, line heights, fonts, etc.
- Pick any fonts from [Google Fonts](https://fonts.google.com/)
- Add icons easily via [Iconify](https://github.com/iconify/iconify) (search for icons on [Icônes](https://icones.js.org/))
- Tex support ([KaTeX](https://github.com/KaTeX/KaTeX))
- Cross-reference (would be useful for an academic CV)
- Case correction (e.g. `Github` -> `GitHub`)
- Add line breaks (`\\[10px]`) or start a new page (`\newpage`) just like in LaTeX
- Break pages automatically
- Customize CSS
- Manage multiple resumes
- Your data in your hands:
  - Data are saved locally within your browser, see the [localForage docs](https://localforage.github.io/localForage/) for details
  - Open-source static website hosted on [Github Pages](https://pages.github.com/), which doesn't (have the ability to) collect your data
  - No user tracking, no ads
- Dark mode

## Reverse Proxy / Self-Hosting

This app is designed to work behind any HTTP reverse proxy (Traefik, Nginx Proxy Manager, Caddy, HAProxy, etc.).

**Container Design:**

- Listens on port 80 (HTTP only—reverse proxy handles HTTPS termination)
- Serves static SPA files with service worker
- Trusts `X-Forwarded-For` and `X-Forwarded-Proto` headers from proxies
- No forced redirects—safe for any deployment architecture

**How to Deploy:**

1. Configure your reverse proxy to:
   - Terminate HTTPS at the proxy layer
   - Forward HTTP traffic to container port 80
   - Pass `X-Forwarded-Proto: https` header (standard for all major proxies)
2. Set environment variables if using a custom domain or subpath:
   - `NUXT_PUBLIC_SITE_URL=https://yourdomain.com`
   - `NUXT_PUBLIC_BASE_URL=/` (or `/resume/` for subpaths)

**Example with Dokploy:**

1. Create a new application and select this GitHub repo
2. Choose **Dockerfile** as the build method
3. In the domain settings, enable HTTPS (Dokploy's Traefik will handle it automatically)
4. Deploy—no additional configuration needed

**Example with Docker Compose + Traefik:**

```yaml
services:
  markdown-resume:
    image: your-registry/markdown-resume:latest
    environment:
      NUXT_PUBLIC_SITE_URL: https://resume.example.com
      NUXT_PUBLIC_BASE_URL: /
    networks:
      - traefik
    labels:
      - traefik.enable=true
      - traefik.http.routers.resume.rule=Host(`resume.example.com`)
      - traefik.http.routers.resume.entrypoints=websecure
      - traefik.http.routers.resume.tls.certresolver=letsencrypt
      - traefik.http.services.resume.loadbalancer.server.port=80

networks:
  traefik:
    external: true
```


## Development

It's built on [Nuxt 3](https://nuxt.com), with the power of [Vue 3](https://github.com/vuejs/vue-next), [Vite](https://github.com/vitejs/vite), [Zag](https://zagjs.com/), and [UnoCSS](https://github.com/antfu/unocss).

Clone the repo and install dependencies:

```bash
pnpm install
```

Build some [packages](packages):

```bash
pnpm build:pkg
```

To enable picking fonts from [Google Fonts](https://fonts.google.com/) (optional), generate a [Google Fonts Developer API Key](https://developers.google.com/fonts/docs/developer_api#APIKey). Then, copy [`site/.env.example`](site/.env.example) to `site/.env` and set:

```env
NUXT_PUBLIC_GOOGLE_FONTS_KEY="YOUR_API_KEY"
```

Start developing / building the site:

```bash
pnpm dev
pnpm build
```

## Support

If this project saved you time, consider supporting it:

- [Ko-fi](https://ko-fi.com/grandday)
- GitHub Sponsors (button on the repo)

## Credits

- The original work: [Renovamen/oh-my-cv](https://github.com/Renovamen/oh-my-cv)
- [billryan/resume](https://github.com/billryan/resume)
- [junian/markdown-resume](https://github.com/junian/markdown-resume)

## License

This project is licensed under [MIT](LICENSE) license.

---

Made with ☕ by [Junian.dev](https://www.junian.dev).

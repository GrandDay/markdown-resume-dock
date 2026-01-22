<h1 align="center">Markdown Resume</h1>

<p align="center">Write an ATS-friendly Resume in Markdown. Available for anyone, Optimized for Dev.</p>



<img align="center" src="https://raw.githubusercontent.com/junian/markdown-resume/assets/img/markdown-resume-screenshot-00.jpg"/>

## About

A fork of "Markdown-Resume". You can visit the original work [here](https://github.com/junian/markdown-resume).
Markdown-Resume is in turn a fork of "Oh My CV!". You can visit the original work [here](https://ohmycv.app).



Changes I made Markdown Resume Fork:
- Dockerfile

## Deployment (Docker / Dokploy)

The image builds to a static site and serves with Nginx. Everything works with **zero config**; use build args only if you need custom domains or subpaths.

```bash
# defaults: base=/ , site url=http://localhost:3000 , name="Markdown Resume"
docker build -t markdown-resume .

# optional: set your domain or subpath
docker build -t markdown-resume \
  --build-arg NUXT_PUBLIC_SITE_URL=https://resume.example.com \
  --build-arg NUXT_PUBLIC_BASE_URL=/ \
  --build-arg NUXT_PUBLIC_SITE_NAME="Your Name" .

docker run -d -p 80:80 markdown-resume
```

For Dokploy, point to the repo, choose **Dockerfile** build, and deploy. Leave build args empty for a root-domain deploy; set `NUXT_PUBLIC_BASE_URL=/resume/` only if you serve under a sub-path.

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

## Credits

- The original work: [Renovamen/oh-my-cv](https://github.com/Renovamen/oh-my-cv)
- [billryan/resume](https://github.com/billryan/resume)
- [junian/markdown-resume](https://github.com/junian/markdown-resume)

## License

This project is licensed under [MIT](LICENSE) license.

---

Made with ☕ by [Junian.dev](https://www.junian.dev).

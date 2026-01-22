# Stage 1: Build the static site
FROM node:20-alpine AS builder

# Enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Copy workspace config and all package.json files for monorepo
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY site/package.json ./site/
COPY packages/correct-case/package.json ./packages/correct-case/
COPY packages/dynamic-css/package.json ./packages/dynamic-css/
COPY packages/front-matter/package.json ./packages/front-matter/
COPY packages/gfonts-loader/package.json ./packages/gfonts-loader/
COPY packages/markdown-it-cross-ref/package.json ./packages/markdown-it-cross-ref/
COPY packages/markdown-it-katex/package.json ./packages/markdown-it-katex/
COPY packages/markdown-it-latex-cmds/package.json ./packages/markdown-it-latex-cmds/
COPY packages/utils/package.json ./packages/utils/
COPY packages/vue-shortcuts/package.json ./packages/vue-shortcuts/
COPY packages/vue-smart-pages/package.json ./packages/vue-smart-pages/
COPY packages/vue-zoom/package.json ./packages/vue-zoom/

# Install dependencies (pnpm will install for all workspace packages)
RUN pnpm install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# --- Build args (optional, with sane defaults) ---
ARG NUXT_PUBLIC_BASE_URL=/
ARG NUXT_PUBLIC_SITE_URL=http://localhost:3000
ARG NUXT_PUBLIC_SITE_NAME="Markdown Resume"
ARG NUXT_PUBLIC_GOOGLE_FONTS_KEY

# Surface build args as env for Nuxt generate
ENV NUXT_PUBLIC_BASE_URL=${NUXT_PUBLIC_BASE_URL}
ENV NUXT_PUBLIC_SITE_URL=${NUXT_PUBLIC_SITE_URL}
ENV NUXT_PUBLIC_SITE_NAME=${NUXT_PUBLIC_SITE_NAME}
ENV NUXT_PUBLIC_GOOGLE_FONTS_KEY=${NUXT_PUBLIC_GOOGLE_FONTS_KEY}
# -------------------------------------------------

# Build workspace packages first
RUN pnpm build:pkg

# Generate the static site
RUN pnpm build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy the static assets
COPY --from=builder /app/site/.output/public /usr/share/nginx/html

# SPA fallback and caching
RUN cat <<'EOF' > /etc/nginx/conf.d/default.conf
server {
	listen 80;
	server_name _;
	root /usr/share/nginx/html;
	index index.html;

	location / {
		try_files $uri $uri/ /index.html;
	}

	location = /sw.js {
		add_header Cache-Control "no-cache";
		try_files $uri $uri/ /sw.js;
	}

	location ~* \.(js|css|png|svg|ico|jpg|jpeg|gif|woff2?|ttf|otf|eot)$ {
		add_header Cache-Control "public, max-age=31536000, immutable";
		try_files $uri =404;
	}
}
EOF

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

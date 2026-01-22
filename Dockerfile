# Stage 1: Build the static site
FROM node:20-alpine AS builder

# Enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Copy dependency files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# --- NEW: Accept Build Args for Site Config ---
ARG SITE_URL
ARG SITE_NAME
ENV SITE_URL=$SITE_URL
ENV SITE_NAME=$SITE_NAME
# ---------------------------------------------

# Generate the static site
RUN pnpm generate

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy the static assets
COPY --from=builder /app/.output/public /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

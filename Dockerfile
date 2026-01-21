# Stage 1: Build the static site
FROM node:20-alpine AS builder

# Enable pnpm (the project uses pnpm)
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Copy dependency files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Generate the static site (Nuxt 3 uses 'generate' for static export)
# This creates the .output/public directory
RUN pnpm generate

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy the static assets from the builder stage
COPY --from=builder /app/.output/public /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

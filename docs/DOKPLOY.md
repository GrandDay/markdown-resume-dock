# Deploying to Dokploy

This guide covers deploying Markdown Resume to Dokploy with Docker Swarm and Traefik.

## Prerequisites

- Dokploy instance running (v0.28.3 or later)
- Domain pointing to your Dokploy server
- GitHub repository access

## Step-by-Step Deployment

### 1. Create the Application

1. Navigate to **Projects** → **New Application**
2. Configure:
   - **Name**: `markdown-resume` (or your choice)
   - **Source**: GitHub
   - **Repository**: Your fork or `GrandDay/markdown-resume-dock`
   - **Branch**: `master`
   - **Build Method**: Dockerfile
   - **Dockerfile Path**: `./Dockerfile`

### 2. Configure Networking

#### Ports Configuration

**Do NOT add any port mappings.** Traefik will communicate with your service via Docker's internal overlay network.

If you accidentally added a port (like `80:80`):

1. Go to **Ports** tab
2. Delete the entry
3. Click **Redeploy**

#### Network Architecture

```text
Internet → Traefik (HTTPS) → Docker Overlay Network → Your App (HTTP:80)
```

Traefik handles:

- SSL/TLS termination
- HTTPS → HTTP proxying
- Let's Encrypt certificates

Your app only needs to serve HTTP on port 80 internally.

### 3. Environment Variables (Optional)

Go to **Environment** tab and add:

| Variable | Value | Description |
|----------|-------|-------------|
| `NUXT_PUBLIC_SITE_URL` | `https://yourdomain.com` | Your public URL |
| `NUXT_PUBLIC_BASE_URL` | `/` | Base path (use `/resume` for subpath) |
| `NUXT_PUBLIC_SITE_NAME` | `My Resume` | Site title |

**Important**: These are **build-time** variables. Changes require a full rebuild.

### 4. Domain and HTTPS

1. Go to **Domains** tab
2. Click **Add Domain**
3. Enter your domain (e.g., `resume.example.com`)
4. Enable **HTTPS**
5. Select **Let's Encrypt** for certificate

### 5. Fix Traefik Service Discovery

This is the **critical step** others often miss.

1. Go to **Advanced** tab (or Traefik configuration)
2. Find the `http.services` section
3. Update the service URL to use the `tasks.` prefix:

```yaml
http:
  routers:
    your-app-router:
      rule: Host(`resume.example.com`)
      service: your-app-service
      entryPoints:
        - websecure
      tls:
        certResolver: letsencrypt
  services:
    your-app-service:
      loadBalancer:
        servers:
          - url: http://tasks.your-app-service-name:80  # ← Note the tasks. prefix
```

**Why `tasks.`?**

- Dokploy's Traefik uses `dnsrr` endpoint mode (DNS Round Robin)
- Standard service names don't resolve in this mode
- The `tasks.` prefix is Docker Swarm's built-in DNS load balancer
- It works regardless of endpoint mode (`vip` or `dnsrr`)

### 6. Deploy

1. Click **Deploy**
2. Monitor logs for build progress
3. Wait for "Nginx started" message
4. Visit your domain (HTTPS should work automatically)

## Common Issues

### "Can't connect to remote host" in Traefik logs

**Cause**: Traefik config uses service name without `tasks.` prefix

**Fix**: Update Traefik config as shown in Step 5

### Published port conflicts (port 80 already allocated)

**Cause**: Accidentally configured published ports in Dokploy

**Fix**:

1. Remove all port mappings in **Ports** tab
2. Redeploy

### 504 Gateway Timeout after enabling HTTPS

**Cause**: Service not on the same Docker network as Traefik

**Fix**: Verify networks match:

```bash
docker service inspect dokploy --format '{{json .Spec.TaskTemplate.Networks}}'
docker service inspect your-service-name --format '{{json .Spec.TaskTemplate.Networks}}'
```

Both should show the same network ID (usually `dokploy-network`).

### Too many redirects

**Cause**: Middleware forcing HTTPS redirect on internal traffic

**Fix**: Check Traefik middlewares—remove any `redirect-to-https` from the websecure router (only needed on the `web` entrypoint).

## Verification

After deployment, test:

```bash
# From Dokploy host
docker service ls  # Should show your service as 1/1 running
docker service logs your-service-name --tail 50  # Check for errors

# Test DNS resolution from Traefik container
docker exec $(docker ps -q -f "name=traefik") \
  nslookup tasks.your-service-name

# Should resolve to 10.0.x.x
```

## PWA Installation

Once deployed over HTTPS:

1. Visit your domain in Chrome/Edge
2. Look for "Install app" icon in the address bar
3. Click to install as a Progressive Web App
4. Works offline after first load

## Additional Resources

- [Dokploy Documentation](https://docs.dokploy.com)
- [Docker Swarm Networking](https://docs.docker.com/engine/swarm/networking/)
- [Traefik Service Discovery](https://doc.traefik.io/traefik/providers/docker/)

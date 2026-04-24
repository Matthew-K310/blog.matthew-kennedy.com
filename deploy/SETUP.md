# Deployment Setup

Static Hugo site served by Caddy.

## Server Setup

### 1. Install dependencies

```bash
# Install Hugo
sudo pacman -S hugo  # or apt install hugo

# Install Caddy
sudo pacman -S caddy  # or see https://caddyserver.com/docs/install
```

### 2. Create directory structure

```bash
sudo mkdir -p /home/deploy/hugo-blog/{source,public}
sudo mkdir -p /home/deploy/hugo-blog.git
sudo chown -R deploy:deploy /home/deploy/hugo-blog*
```

### 3. Set up bare git repo

```bash
cd /home/deploy/hugo-blog.git
git init --bare

# Install the post-receive hook
cp /path/to/deploy/hooks/post-receive hooks/post-receive
chmod +x hooks/post-receive
```

### 4. Configure Caddy

```bash
# Copy Caddyfile
sudo cp deploy/Caddyfile /etc/caddy/Caddyfile

# Enable and start Caddy
sudo systemctl enable caddy
sudo systemctl start caddy
```

### 5. Remove old hugo server service

```bash
sudo systemctl stop blog
sudo systemctl disable blog
sudo rm /etc/systemd/system/blog.service
sudo systemctl daemon-reload
```

### 6. Add remote to local repo

```bash
git remote add deploy deploy@your-server:/home/deploy/hugo-blog.git
```

## Deploying

```bash
git push deploy main
```

The post-receive hook will:
1. Checkout the code to `/home/deploy/hugo-blog/source`
2. Run `hugo --minify` to build static files to `/home/deploy/hugo-blog/public`
3. Caddy serves the public directory automatically (no restart needed)

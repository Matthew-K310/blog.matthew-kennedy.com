#!/bin/bash
# Exit on error
set -e

DEPLOY_DIR="/home/deploy/hugo-blog"
SOURCE_DIR="${DEPLOY_DIR}/source"
PUBLIC_DIR="${DEPLOY_DIR}/public"

echo "Building Hugo site..."
cd "${SOURCE_DIR}"

# Update submodules (themes)
git submodule update --init --recursive

# Build the site
hugo --minify --destination "${PUBLIC_DIR}"

echo "Build complete. Static files in ${PUBLIC_DIR}"
echo "Caddy will serve these automatically."

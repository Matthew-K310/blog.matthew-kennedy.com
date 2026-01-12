
#!/bin/bash
# Exit on error
set -e

# Check if commit hash is passed as an argument
if [ -z "$1" ]; then
	echo "Usage: $0 <commit-hash>"
	exit 1
fi

COMMIT_HASH=$1
DEPLOY_DIR="/home/deploy/hugo-blog"
STAGING_DIR="${DEPLOY_DIR}/staging"
CURRENT_DIR="${DEPLOY_DIR}/current"
SERVICE_NAME="hugo-blog"

# Create current directory if it doesn't exist
mkdir -p "${CURRENT_DIR}"

# Copy files from staging to current directory
echo "Deploying commit ${COMMIT_HASH} to ${CURRENT_DIR}..."
rsync -a --delete \
  --exclude '.git' \
  --exclude '.github' \
  "${STAGING_DIR}/" "${CURRENT_DIR}/"

echo "Files deployed successfully."

# Restart the service
SERVICE="${SERVICE_NAME}.service"
echo "Restarting ${SERVICE}..."
sudo systemctl restart "$SERVICE"

WAIT_TIME=5
echo "Waiting for ${SERVICE} to start..."
sleep $WAIT_TIME

# Check the status of the service
if systemctl is-active --quiet "${SERVICE}"; then
	echo "${SERVICE} restarted successfully."
	echo "Deployment completed successfully."
else
	echo "Warning: ${SERVICE} may not have started correctly."
	sudo systemctl status "${SERVICE}" --no-pager
	exit 1
fi

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
RELEASES_DIR="${DEPLOY_DIR}/releases"
CURRENT_LINK="${DEPLOY_DIR}/current"
SERVICE_NAME="blog"

# Create releases directory if it doesn't exist
mkdir -p "${RELEASES_DIR}"

# Keep a reference to the previous release from the symlink
if [ -L "${CURRENT_LINK}" ]; then
	PREVIOUS=$(readlink -f "${CURRENT_LINK}")
	echo "Current release is ${PREVIOUS}, saved for rollback."
else
	echo "No symbolic link found, no previous release to backup."
	PREVIOUS=""
fi

rollback_deployment() {
	if [ -n "$PREVIOUS" ]; then
		echo "Rolling back to previous release: ${PREVIOUS}"
		ln -sfn "${PREVIOUS}" "${CURRENT_LINK}"
	else
		echo "No previous release to roll back to."
	fi
	
	# Wait before restarting the service
	sleep 10
	
	# Restart service with the previous release
	SERVICE="${SERVICE_NAME}.service"
	echo "Restarting $SERVICE..."
	sudo systemctl restart $SERVICE
	echo "Rollback completed."
}

# Create a new release directory for this commit
RELEASE_DIR="${RELEASES_DIR}/${COMMIT_HASH}"
echo "Creating new release at ${RELEASE_DIR}..."
mkdir -p "${RELEASE_DIR}"

# Copy files from staging to the release directory
echo "Copying files from staging to release..."
cp -r "${STAGING_DIR}"/* "${RELEASE_DIR}/"

# Update the current symlink to point to the new release
echo "Promoting release ${COMMIT_HASH} to current..."
ln -sfn "${RELEASE_DIR}" "${CURRENT_LINK}"

WAIT_TIME=5

restart_service() {
	local SERVICE="${SERVICE_NAME}.service"
	echo "Restarting ${SERVICE}..."
	
	# Restart the service
	if ! sudo systemctl restart "$SERVICE"; then
		echo "Error: Failed to restart ${SERVICE}. Rolling back deployment."
		rollback_deployment
		exit 1
	fi
	
	# Wait a few seconds to allow the service to fully start
	echo "Waiting for ${SERVICE} to fully start..."
	sleep $WAIT_TIME
	
	# Check the status of the service
	if ! systemctl is-active --quiet "${SERVICE}"; then
		echo "Error: ${SERVICE} failed to start correctly. Rolling back deployment."
		rollback_deployment
		exit 1
	fi
	
	echo "${SERVICE} restarted successfully."
}

restart_service

# Clean up old releases (keep last 5)
echo "Cleaning up old releases..."
cd "${RELEASES_DIR}"
ls -t | tail -n +6 | xargs -r rm -rf

echo "Deployment completed successfully."
echo "Active release: ${COMMIT_HASH}"
echo "Blog location: ${CURRENT_LINK}"

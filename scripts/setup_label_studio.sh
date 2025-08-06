#!/bin/bash
set -e
# Clean all volume bindings due to Docker Compose if needed

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/.." || exit 1
(

sudo rm -rf ./postgres-data ./mydata ./deploy/pgsql/certs ./deploy/nginx/certs

echo "📦 Cleaning up existing data and cert directories..."
echo "📁 Recreating directory structure..."
mkdir -p ./postgres-data
mkdir -p ./mydata
mkdir -p ./deploy/pgsql/certs
mkdir -p ./deploy/nginx/certs

echo "🔒 Setting permissions for volumes (UID 1001 = label-studio user)..."
sudo chown -R 1001:1001 ./postgres-data ./mydata

echo "✅ Done setting up Label Studio directories and volume mounts!"

)


#!/bin/bash

# Clean all volume bindings due to Docker Compose if needed
# sudo rm -rf ./postgres-data ./mydata ./deploy/pgsql/certs ./deploy/nginx/certs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DIRECTORY="${SCRIPT_DIR}/../mydata"

mkdir -p ${DIRECTORY}
sudo chown -R 1001:1001 ${DIRECTORY}

mkdir -p deploy
touch ${SCRIPT_DIR}/../deploy/default.conf
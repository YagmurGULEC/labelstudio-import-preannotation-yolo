#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

aws s3 cp "${SCRIPT_DIR}/../data_2012.tar.gz" s3://label-studio-crawler-bucket/data_2012.tar.gz
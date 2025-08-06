#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../.env"
 


curl -X GET http://localhost:8080/api/projects/ -H "Authorization: Token $LABEL_STUDIO_TOKEN"

# Create a new project
curl -X POST http://localhost:8080/api/projects/ \
     -H "Authorization: Token $LABEL_STUDIO_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "title": "VOC Dataset Project",
            "description": "Project for VOC dataset annotation",
            "label_config": "<View><Image name=\"image\" value=\"$image\"/><Text name=\"text\" value=\"$text\"/></View>"
            "labels": [
                {}
            ]
            }'
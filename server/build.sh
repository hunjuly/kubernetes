#!/bin/bash
set -ex
cd "$(dirname "$0")"

# docker run -d -p 5000:5000 --restart always --name registry registry:2

docker build -t node-server:2 .

# curl -X GET http://localhost:5000/v2/_catalog
# curl -X GET http://localhost:5000/v2/server/tags/list

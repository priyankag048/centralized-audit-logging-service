#!/bin/bash

set -e

IMAGE_TAG=${1:-latest}

echo "Building tenant-log-sim image..."
docker build -t priyankaguha/tenant-log-sim:${IMAGE_TAG} -f ../../applications/tenant-log-sim/Dockerfile .







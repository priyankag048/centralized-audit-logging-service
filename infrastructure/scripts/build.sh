#!/bin/bash

set -e

IMAGE_TAG_LOG=${1:-latest}

echo "Building tenant-log-sim image..."
docker build -t priyankaguha/tenant-log-sim:${IMAGE_TAG_LOG} -f ../../applications/tenant-log-sim/Dockerfile .


IMAGE_TAG_PROCESSOR=${1:-latest}
echo "Building tenant-log-processor image..."
docker build -t priyankaguha/tenant-log-processor:${IMAGE_TAG_PROCESSOR} -f ../../applications/tenant-log-processor/Dockerfile .







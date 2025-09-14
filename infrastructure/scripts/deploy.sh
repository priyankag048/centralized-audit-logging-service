#!/bin/bash
set -e

echo "Deploying tenant-log-sim CronJob..."
helm upgrade --install tenant-log-sim ../helm-charts/tenant-log-sim \
  -n logging

echo "Verify cronjobs"
kubectl get cronjob -n logging


echo "Deploying tenant-log-processor..."
helm upgrade --install tenant-log-sim ../helm-charts/tenant-log-processor \
  -n logging

echo "Verify deployments"
kubectl get deployment -n logging | grep -E tenant-log-processor
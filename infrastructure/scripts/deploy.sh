#!/bin/bash
set -e

echo "Deploying tenant-log-sim CronJob..."
helm upgrade --install tenant-log-sim ../helm-charts/tenant-log-sim \
  -n logging

echo "Verify cronjobs"
kubectl get cronjob -n logging



#!/bin/bash

set -e

echo "[1/8] Creating Namespace..."
kubectl create namespace logging

echo "[2/8] Installing Fluent Bit..."
helm upgrade --install fluent-bit ../helm-charts/fluent-bit -n logging

echo "[3/8] Installing Fluentd..."
helm upgrade --install fluentd ../helm-charts/fluentd -n logging

echo "[4/8] Installing Postgres..."
helm install postgresql bitnami/postgresql \
  --set auth.username=priyankaguha \
  --set auth.password=*** \
  --set auth.database=auditdb \
  --set primary.persistence.enabled=false


echo "[5/8] Installing Kafka and Zookeeper..."
helm upgrade --install kafka ../helm-charts/kafka -n logging

echo "[6/8] Verify deployments and pods"
kubectl wait --for=condition=ready pod/kafka-0 -n logging --timeout=120s
kubectl get pod -n logging

echo "[7/8] Create kafka topics"
kubectl -n logging exec -it kafka-0 -- bash -c "\
kafka-topics --bootstrap-server localhost:9092 --create --topic tenant-logs --partitions 3 --replication-factor 1 && \
kafka-topics --bootstrap-server localhost:9092 --create --topic tenant-logs-dlq --partitions 1 --replication-factor 1"


echo "[8/8] Verify kafka topics"
kubectl -n logging exec -it kafka-0 -- bash -c "\
kafka-topics --bootstrap-server localhost:9092 --list"
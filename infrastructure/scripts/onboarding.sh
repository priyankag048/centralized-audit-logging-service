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
  --set auth.username=** \
  --set auth.password=*** \
  --set auth.database=auditdb \
  --set primary.persistence.enabled=false

echo "[5/8] Installing Kafka and Zookeeper..."
helm upgrade --install kafka ../helm-charts/kafka -n logging

echo "[6/8] Verify pods are ready to accept traffic"

echo "Verify Kafka is ready"
kubectl wait --for=condition=ready pod/kafka-0 -n logging --timeout=120s
kubectl get pods -n logging | grep -E zookeeper

echo "Verify PostgreSQL is ready"
kubectl wait --for=condition=ready pod/postgresql-0 -n logging --timeout=120s

echo "Verify fluentbit and fluentd pods"
kubectl get pods -n logging | grep -E fluent

echo "[7/8] Create kafka topics"
kubectl -n logging exec -it kafka-0 -- bash -c "\
kafka-topics --bootstrap-server localhost:9092 --create --topic tenant-logs --partitions 3 --replication-factor 1 && \
kafka-topics --bootstrap-server localhost:9092 --create --topic tenant-logs-dlq --partitions 1 --replication-factor 1"

echo "Verify kafka topics are created"
kubectl -n logging exec -it kafka-0 -- bash -c "\
kafka-topics --bootstrap-server localhost:9092 --list"

echo "[8/8] Migrate database"
helm upgrade --install pg-migration ./db-migrate -n logging

echo "Verify migration was successful"
kubectl wait --for=condition=complete job/pg-migration -n logging --timeout=120s
MIGRATION_POD=$(kubectl get pods -n logging | grep -E postgres-migration)
kubectl logs -n logging $MIGRATION_POD

echo "======== Set up Completed ==========="

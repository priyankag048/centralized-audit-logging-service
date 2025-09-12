#!/bin/bash

set -e

echo "[1/7] Creating Namespace..."
kubectl create namespace logging

echo "[2/7] Installing Fluent Bit..."
helm upgrade --install fluent-bit ../helm-charts/fluent-bit -n logging

echo "[3/7] Installing Fluentd..."
helm upgrade --install fluentd ../helm-charts/fluentd -n logging

echo "[4/7] Installing Kafka and Zookeeper..."
helm upgrade --install kafka ../helm-charts/kafka -n logging

echo "[5/7] Verify deployments and pods"
kubectl wait --for=condition=ready pod/kafka-0 -n logging --timeout=120s
kubectl get pod -n logging

echo "[6/7] Create kafka topics"
kubectl -n logging exec -it kafka-0 -- bash -c "\
kafka-topics --bootstrap-server localhost:9092 --create --topic tenant-logs --partitions 3 --replication-factor 1 && \
kafka-topics --bootstrap-server localhost:9092 --create --topic tenant-logs-dlq --partitions 1 --replication-factor 1"


echo "[7/7] Verify kafka topics"
kubectl -n logging exec -it kafka-0 -- bash -c "\
kafka-topics --bootstrap-server localhost:9092 --list"
#!/usr/bin/env bash
set -euo pipefail
: "${KAFKA_HOME:?Set KAFKA_HOME, for example: export KAFKA_HOME=/home/venkatesh/kafka}"
BOOTSTRAP_SERVERS="${KAFKA_BOOTSTRAP_SERVERS:-localhost:9092}"
for topic in test-topic sensor-data; do
  "$KAFKA_HOME/bin/kafka-topics.sh" --bootstrap-server "$BOOTSTRAP_SERVERS" --create --if-not-exists --topic "$topic" --partitions 1 --replication-factor 1
done

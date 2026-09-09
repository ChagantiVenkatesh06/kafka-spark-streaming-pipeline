#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -z "${KAFKA_HOME:-}" && -x "$PROJECT_DIR/.runtime/kafka/bin/kafka-topics.sh" ]]; then
  source "$PROJECT_DIR/scripts/project_env.sh"
fi
: "${KAFKA_HOME:?Run ./scripts/setup_local_runtime.sh or set KAFKA_HOME first.}"
BOOTSTRAP_SERVERS="${KAFKA_BOOTSTRAP_SERVERS:-localhost:9092}"

for topic in test-topic sensor-data; do
  "$KAFKA_HOME/bin/kafka-topics.sh" --bootstrap-server "$BOOTSTRAP_SERVERS" --create --if-not-exists --topic "$topic" --partitions 1 --replication-factor 1
done

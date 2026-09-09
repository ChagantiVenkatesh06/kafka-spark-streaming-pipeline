#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_DIR/scripts/project_env.sh"
CONFIG_FILE="$PROJECT_DIR/.runtime/kafka-local.properties"
DATA_DIR="$PROJECT_DIR/.runtime/kafka-data"

if [[ ! -x "$KAFKA_HOME/bin/kafka-server-start.sh" || ! -f "$CONFIG_FILE" ]]; then
  echo "Local Kafka is not installed. Run ./scripts/setup_local_runtime.sh first." >&2
  exit 1
fi

if ss -ltn 2>/dev/null | grep -q ':9092 '; then
  echo "A Kafka service is already listening on port 9092."
  exit 0
fi

if [[ ! -f "$DATA_DIR/meta.properties" ]]; then
  CLUSTER_ID="$("$KAFKA_HOME/bin/kafka-storage.sh" random-uuid)"
  "$KAFKA_HOME/bin/kafka-storage.sh" format --standalone --cluster-id "$CLUSTER_ID" --config "$CONFIG_FILE"
fi

nohup "$KAFKA_HOME/bin/kafka-server-start.sh" "$CONFIG_FILE" > "$PROJECT_DIR/logs/kafka-local.log" 2>&1 &
echo "Started local Kafka. Log: $PROJECT_DIR/logs/kafka-local.log"

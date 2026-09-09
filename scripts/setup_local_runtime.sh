#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME_DIR="$PROJECT_DIR/.runtime"
KAFKA_VERSION="4.3.1"
KAFKA_ARCHIVE="kafka_2.13-$KAFKA_VERSION.tgz"
KAFKA_URL="https://downloads.apache.org/kafka/$KAFKA_VERSION/$KAFKA_ARCHIVE"

command -v curl >/dev/null || { echo "curl is required." >&2; exit 1; }
command -v tar >/dev/null || { echo "tar is required." >&2; exit 1; }

mkdir -p "$RUNTIME_DIR"
if [[ ! -x "$RUNTIME_DIR/jdk/bin/java" ]]; then
  temp_jdk="$(mktemp)"
  curl -fL --retry 3 "https://api.adoptium.net/v3/binary/latest/21/ga/linux/x64/jdk/hotspot/normal/eclipse" -o "$temp_jdk"
  mkdir -p "$RUNTIME_DIR/jdk-extracted"
  tar -xzf "$temp_jdk" -C "$RUNTIME_DIR/jdk-extracted" --strip-components=1
  rm -f "$temp_jdk"
  mv "$RUNTIME_DIR/jdk-extracted" "$RUNTIME_DIR/jdk"
fi

if [[ ! -x "$RUNTIME_DIR/kafka/bin/kafka-server-start.sh" ]]; then
  temp_kafka="$(mktemp)"
  curl -fL --retry 3 "$KAFKA_URL" -o "$temp_kafka"
  mkdir -p "$RUNTIME_DIR/kafka"
  tar -xzf "$temp_kafka" -C "$RUNTIME_DIR/kafka" --strip-components=1
  rm -f "$temp_kafka"
fi

mkdir -p "$RUNTIME_DIR/kafka-data" "$PROJECT_DIR/logs"
sed "s|__KAFKA_DATA_DIR__|$RUNTIME_DIR/kafka-data|g" \
  "$PROJECT_DIR/config/kafka-local.properties" > "$RUNTIME_DIR/kafka-local.properties"

echo "Local Java and Kafka runtimes are ready in $RUNTIME_DIR"
echo "Run ./scripts/start_local_kafka.sh next."

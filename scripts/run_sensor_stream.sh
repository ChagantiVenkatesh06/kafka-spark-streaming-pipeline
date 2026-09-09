#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPARK_SUBMIT="${SPARK_SUBMIT:-$PROJECT_DIR/.venv/bin/spark-submit}"

if [[ ! -x "$SPARK_SUBMIT" ]]; then
  echo "Spark is not installed for this project. Run ./scripts/install_python_dependencies.sh first." >&2
  exit 1
fi

"$SPARK_SUBMIT" \
  --packages org.apache.spark:spark-sql-kafka-0-10_2.13:4.2.0 \
  "$PROJECT_DIR/src/sensor_stream.py"

#!/usr/bin/env bash
set -euo pipefail
: "${SPARK_HOME:?Set SPARK_HOME, for example: export SPARK_HOME=/home/venkatesh/spark}"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"$SPARK_HOME/bin/spark-submit" --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.1 "$PROJECT_DIR/src/kafka_word_count.py"

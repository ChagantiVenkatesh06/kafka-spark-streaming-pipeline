#!/usr/bin/env bash

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PROJECT_DIR
export JAVA_HOME="$PROJECT_DIR/.runtime/jdk"
export KAFKA_HOME="$PROJECT_DIR/.runtime/kafka"
export PATH="$JAVA_HOME/bin:$KAFKA_HOME/bin:$PATH"
export KAFKA_BOOTSTRAP_SERVERS="${KAFKA_BOOTSTRAP_SERVERS:-localhost:9092}"

# Kafka Spark Streaming Pipeline

A real-time Apache Kafka and Apache Spark Structured Streaming project.

The project provides:

- a Kafka word-count stream for `test-topic`
- a JSON sensor stream for `sensor-data`
- a Python Kafka producer
- a project-local Python environment, isolated from system Python packages

## Current versions

- Python 3.10+
- PySpark 4.2.0
- kafka-python 3.0.11
- Java 17 or 21
- Kafka broker: configure separately; it is not a Python package

## Install Python requirements

From the repository root:

```bash
./scripts/install_python_dependencies.sh
```

This creates `.venv` inside the repository and runs the equivalent of:

```bash
.venv/bin/python -m pip install -r requirements.txt
```

No Python packages are installed globally.

## Kafka broker setup

For your existing Kafka installation:

```bash
export KAFKA_HOME=/home/venkatesh/kafka
export KAFKA_BOOTSTRAP_SERVERS=localhost:9092
$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties
```

In a separate terminal:

```bash
export KAFKA_HOME=/home/venkatesh/kafka
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
```

Create project topics:

```bash
export KAFKA_HOME=/home/venkatesh/kafka
./scripts/create_topics.sh
```

## Run word count

In one terminal:

```bash
./scripts/run_word_count.sh
```

In another terminal:

```bash
.venv/bin/python src/producer.py --message "spark kafka streaming works"
```

## Run sensor streaming

In one terminal:

```bash
./scripts/run_sensor_stream.sh
```

In another terminal:

```bash
.venv/bin/python src/producer.py --topic sensor-data --sensor
```

The current Spark 4.2 connector uses Scala 2.13, which is why the scripts use `spark-sql-kafka-0-10_2.13:4.2.0`.

# Kafka Spark Streaming Pipeline

A real-time Apache Kafka and Apache Spark Structured Streaming project.

The repository is intentionally source-only. One setup command downloads isolated project runtimes, keeping existing Kafka, Spark, Java, ZooKeeper, and Python installations untouched.

## Versions

- Java 21, downloaded locally from Eclipse Temurin
- Apache Kafka 4.3.1, downloaded locally in KRaft mode
- PySpark 4.2.0, installed in `.venv`
- kafka-python 3.0.11, installed in `.venv`

Kafka 4.3 uses KRaft and does not require ZooKeeper.

## First-time setup

From the repository root:

```bash
./scripts/setup_local_runtime.sh
./scripts/install_python_dependencies.sh
./scripts/start_local_kafka.sh
./scripts/create_topics.sh
```

The setup creates these ignored directories:

```text
.runtime/jdk/      Local Java 21 runtime
.runtime/kafka/    Local Kafka 4.3.1 runtime
.venv/             Local Python, PySpark, and Kafka client packages
```

## Run word count

Terminal 1:

```bash
./scripts/run_word_count.sh
```

Terminal 2:

```bash
.venv/bin/python src/producer.py --message "spark kafka streaming works"
```

## Run sensor streaming

Terminal 1:

```bash
./scripts/run_sensor_stream.sh
```

Terminal 2:

```bash
.venv/bin/python src/producer.py --topic sensor-data --sensor
```

## Stop Kafka

```bash
pkill -f kafka.Kafka
```

The runtimes are downloaded from official Apache Kafka and Eclipse Temurin endpoints; no Kafka, Spark, or Java binaries are committed to GitHub.

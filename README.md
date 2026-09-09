# Kafka Spark Streaming Pipeline

A reproducible Apache Kafka and Apache Spark Structured Streaming project.

It includes a real-time word count for `test-topic`, a JSON sensor stream for `sensor-data`, and a Python producer. Kafka and Spark distributions are not included.

## Prerequisites

- Java 11+
- Apache Kafka 3.7.0
- Apache Spark 3.5.1
- Python 3.8+

For this WSL machine:

```bash
export KAFKA_HOME=/home/venkatesh/kafka
export SPARK_HOME=/home/venkatesh/spark
export KAFKA_BOOTSTRAP_SERVERS=localhost:9092
```

In `$KAFKA_HOME/config/server.properties`, Kafka must use:

```properties
listeners=PLAINTEXT://0.0.0.0:9092
advertised.listeners=PLAINTEXT://localhost:9092
```

## Run word count

In terminal 1:

```bash
cd /home/venkatesh/kafka-spark-streaming-pipeline
export KAFKA_HOME=/home/venkatesh/kafka
$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties
```

In terminal 2:

```bash
export KAFKA_HOME=/home/venkatesh/kafka
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
```

In terminal 3:

```bash
cd /home/venkatesh/kafka-spark-streaming-pipeline
export KAFKA_HOME=/home/venkatesh/kafka
./scripts/create_topics.sh
export SPARK_HOME=/home/venkatesh/spark
./scripts/run_word_count.sh
```

In terminal 4:

```bash
cd /home/venkatesh/kafka-spark-streaming-pipeline
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python src/producer.py --message "spark kafka streaming works"
```

The Spark terminal prints cumulative word counts.

## Run sensor stream

```bash
export SPARK_HOME=/home/venkatesh/spark
$SPARK_HOME/bin/spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.1 src/sensor_stream.py
source .venv/bin/activate
python src/producer.py --topic sensor-data --sensor
```

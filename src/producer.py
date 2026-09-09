import argparse
import json
import os
from datetime import datetime, timezone

from kafka import KafkaProducer

parser = argparse.ArgumentParser(description="Send a message to Kafka.")
parser.add_argument("--topic", default=os.getenv("KAFKA_TOPIC", "test-topic"))
parser.add_argument("--message")
parser.add_argument("--sensor", action="store_true")
args = parser.parse_args()

if not args.message and not args.sensor:
    parser.error("pass --message TEXT or --sensor")

payload = args.message or {
    "temperature": 28.5,
    "humidity": 64.0,
    "timestamp": datetime.now(timezone.utc).isoformat(),
}
producer = KafkaProducer(
    bootstrap_servers=os.getenv("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092"),
    value_serializer=lambda value: value.encode("utf-8") if isinstance(value, str) else json.dumps(value).encode("utf-8"),
)
producer.send(args.topic, payload).get(timeout=10)
producer.flush()
print(f"Sent message to {args.topic}: {payload}")

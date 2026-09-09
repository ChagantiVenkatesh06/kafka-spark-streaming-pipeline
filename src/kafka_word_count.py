import os

from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split

bootstrap_servers = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092")
topic = os.getenv("KAFKA_TOPIC", "test-topic")
checkpoint_dir = os.getenv("CHECKPOINT_DIR", ".spark-checkpoints/word-count")

spark = SparkSession.builder.appName("KafkaWordCount").getOrCreate()
spark.sparkContext.setLogLevel("WARN")

messages = (
    spark.readStream.format("kafka")
    .option("kafka.bootstrap.servers", bootstrap_servers)
    .option("subscribe", topic)
    .option("startingOffsets", "latest")
    .load()
)

words = messages.select(explode(split(messages.value.cast("string"), r"\s+")).alias("word"))
counts = words.filter("word <> ''").groupBy("word").count()

query = (
    counts.writeStream.outputMode("complete")
    .format("console")
    .option("checkpointLocation", checkpoint_dir)
    .start()
)
query.awaitTermination()

import os

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_json
from pyspark.sql.types import DoubleType, StringType, StructField, StructType

schema = StructType([
    StructField("temperature", DoubleType(), True),
    StructField("humidity", DoubleType(), True),
    StructField("timestamp", StringType(), True),
])

spark = SparkSession.builder.appName("KafkaSensorStream").getOrCreate()
spark.sparkContext.setLogLevel("WARN")
messages = (
    spark.readStream.format("kafka")
    .option("kafka.bootstrap.servers", os.getenv("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092"))
    .option("subscribe", os.getenv("SENSOR_TOPIC", "sensor-data"))
    .load()
)
events = messages.select(from_json(col("value").cast("string"), schema).alias("event")).select("event.*")
query = events.writeStream.format("console").outputMode("append").option(
    "checkpointLocation", os.getenv("CHECKPOINT_DIR", ".spark-checkpoints/sensor-stream")
).start()
query.awaitTermination()

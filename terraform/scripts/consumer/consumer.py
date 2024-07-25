from kafka import KafkaConsumer
import json
import tensorflow as tf
import numpy as np

consumer = KafkaConsumer('metrics',
                         bootstrap_servers='kafka.kafka.svc.cluster.local:9092',
                         value_deserializer=lambda x: json.loads(x.decode('utf-8')))

model = tf.keras.models.load_model('/path/to/your/model')
threshold = 0.8  # Define your threshold for anomaly

def detect_anomalies(data):
    prediction = model.predict(np.array([data['value']]))
    return prediction[0] > threshold

for message in consumer:
    data = message.value
    if detect_anomalies(data):
        print(f"Anomaly detected: {data}")

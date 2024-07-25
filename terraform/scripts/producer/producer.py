from kafka import KafkaProducer
import json
import time
import random

producer = KafkaProducer(bootstrap_servers='kafka.kafka.svc.cluster.local:9092',
                         value_serializer=lambda v: json.dumps(v).encode('utf-8'))

def generate_data():
    while True:
        data = {
            'metric': 'cpu_usage',
            'value': random.uniform(0, 100),
            'timestamp': int(time.time())
        }
        producer.send('metrics', data)
        time.sleep(1)

if __name__ == "__main__":
    generate_data()

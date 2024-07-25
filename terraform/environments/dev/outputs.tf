output "kafka_service" {
  value = module.kafka.kafka_service
}

output "tensorflow_serving_url" {
  value = module.tensorflow_serving.tensorflow_serving_url
}

output "producer_deployment" {
  value = module.producer.producer_deployment
}

output "consumer_deployment" {
  value = module.consumer.consumer_deployment
}

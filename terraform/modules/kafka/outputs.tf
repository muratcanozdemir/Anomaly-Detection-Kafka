output "kafka_service" {
  value = helm_release.kafka.status[0].url
}

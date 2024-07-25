output "consumer_deployment" {
  value = kubernetes_deployment.consumer.metadata[0].name
}

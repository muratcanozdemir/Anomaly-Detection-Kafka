output "producer_deployment" {
  value = kubernetes_deployment.producer.metadata[0].name
}

output "tensorflow_serving_url" {
  value = kubernetes_service.tensorflow_serving.status[0].load_balancer.ingress[0].hostname
}

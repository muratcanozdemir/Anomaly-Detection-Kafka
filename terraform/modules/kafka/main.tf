provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

resource "helm_release" "kafka" {
  name       = "kafka"
  namespace  = "kafka"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"

  set {
    name  = "replicaCount"
    value = "1"
  }
}

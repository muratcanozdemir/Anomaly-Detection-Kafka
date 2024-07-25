resource "kubernetes_namespace" "consumer" {
  metadata {
    name = "consumer"
  }
}

resource "kubernetes_deployment" "consumer" {
  #checkov:skip=CKV_K8S_43 I don't want to use digest
  metadata {
    name      = "kafka-consumer:v1.0"
    namespace = kubernetes_namespace.consumer.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "kafka-consumer"
      }
    }
    template {
      metadata {
        labels = {
          app = "kafka-consumer"
        }
      }
      spec {
        container {
          name  = "kafka-consumer"
          image = "${var.consumer_image}@v1.0"
          port {
            container_port = 80
          }
          image_pull_policy = "Always"
          security_context {
            capabilities {
              drop = ["ALL", "NET-RAW"]
            }
            read_only_root_filesystem = true
          }
          liveness_probe {
            
          }
          readiness_probe {
            
          }
          resources {
            limits = {
              cpu = 2
              memory = 4096
            }
            requests = {
              cpu = 1
              memory = 2048
            }
          }
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

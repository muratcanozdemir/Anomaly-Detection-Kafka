resource "kubernetes_namespace" "producer" {
  metadata {
    name = "producer"
  }
}

resource "kubernetes_deployment" "producer" {
  #checkov:skip=CKV_K8S_43 I don't want to use digest
  metadata {
    name      = "kafka-producer:v1.0"
    namespace = kubernetes_namespace.producer.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "kafka-producer"
      }
    }
    template {
      metadata {
        labels = {
          app = "kafka-producer"
        }
      }
      spec {
        container {
          name  = "kafka-producer"
          image = "${var.producer_image}@v1.0"
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

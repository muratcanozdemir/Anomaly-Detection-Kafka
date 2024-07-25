resource "kubernetes_namespace" "tensorflow" {
  metadata {
    name = "tensorflow"
  }
}

resource "kubernetes_deployment" "tensorflow_serving" {
  metadata {
    name      = "tensorflow-serving:v1.0"
    namespace = kubernetes_namespace.tensorflow.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "tensorflow-serving"
      }
    }
    template {
      metadata {
        labels = {
          app = "tensorflow-serving"
        }
      }
      spec {
        container {
          #checkov:skip=CKV_K8S_43 I don't want to use digest
          name  = "tensorflow-serving"
          image = "tensorflow/serving:2.17.0-gpu"
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
          
          args  = [
            "--rest_api_port=8501",
            "--model_name=my_model",
            "--model_base_path=/models/my_model"
          ]
          port {
            container_port = 8501
          }
          volume_mount {
            mount_path = "/models/my_model"
            name       = "model-volume"
          }
        }
        volume {
          name = "model-volume"
          host_path {
            path = var.model_path
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "tensorflow_serving" {
  metadata {
    name      = "tensorflow-serving"
    namespace = kubernetes_namespace.tensorflow.metadata[0].name
  }
  spec {
    selector = {
      app = "tensorflow-serving"
    }
    port {
      protocol = "TCP"
      port     = 8501
      target_port = 8501
    }
  }
}

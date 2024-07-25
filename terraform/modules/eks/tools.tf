resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = "default"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "6.0.0" # Specify the version you need

  values = [
    <<EOF
    provider: aws
    aws:
      region: ${var.region}
    policy: sync
    txtOwnerId: ${var.cluster_name}
    EOF
  ]
}

#-------------------------------------------------
# ARGO-CD ----------------------------------------
#-------------------------------------------------

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "3.23.0" 

  create_namespace = true

  depends_on = [
    kubernetes_namespace.argocd
  ]
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  data = {
    "admin.password"       = base64encode(data.aws_secretsmanager_secret_version.argocd_admin_password.secret_string)
    "admin.passwordMtime"  = timestamp()
  }
}

resource "random_password" "argocd_admin" {
  length  = 16
  special = true
}

resource "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  data = {
    "admin.password"       = base64encode(random_password.argocd_admin.result)
    "admin.passwordMtime"  = timestamp()
  }
}

resource "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
    annotations = {
      "external-dns.alpha.kubernetes.io/hostname" = "argocd.${var.domain}"
    }
  }

  spec {
    selector = {
      app.kubernetes.io/name = "argocd-server"
    }

    port {
      port        = 80
      target_port = 8080
    }

    port {
      port        = 443
      target_port = 8443
    }

    type = "LoadBalancer"
  }

  depends_on = [helm_release.argocd]
}

output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "kubeconfig" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "node_group_id" {
  value = aws_eks_node_group.this.id
}

output "argocd_admin_password" {
  value     = kubernetes_secret.argocd_admin_password.data["admin.password"]
  sensitive = true
}

output "argocd_dns_name" {
  value = "argocd.${var.domain}"
}

resource "kubernetes_manifest" "root_cluster_issuer" {
  manifest = yamldecode(file("${path.module}/root-cluster-issuer.yaml"))
}

resource "kubernetes_manifest" "ca_certificate" {
  manifest = yamldecode(file("${path.module}/ca-certificate.yaml"))
}

resource "kubernetes_manifest" "leaf_cluster_issuer" {
  manifest = yamldecode(file("${path.module}/leaf-cluster-issuer.yaml"))
}

# ECDSA key with P384 elliptic curve
resource "tls_private_key" "ecdsa_p384" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "kong_cluster_cert" {
  private_key_pem = tls_private_key.ecdsa_p384.private_key_pem

  subject {
    common_name  = "kong_clustering"
    organization = "Demo Inc"
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

resource "kubernetes_secret" "kong_demo_cluster_cert" {
  metadata {
    name = "kong-cluster-cert"
    namespace = var.namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = tls_self_signed_cert.kong_cluster_cert.cert_pem
    "tls.key" = tls_private_key.ecdsa_p384.private_key_pem
  }
}

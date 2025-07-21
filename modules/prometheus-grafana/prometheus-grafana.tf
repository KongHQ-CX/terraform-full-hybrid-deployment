resource "helm_release" "prometheus" {
  name       = "prometheus"
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "25.0.0"
  namespace  = var.namespace

  values = [templatefile("${path.module}/prometheus-values.yaml.tpl", {
    ingress_domain = var.ingress_domain
  })]
}

resource "helm_release" "grafana" {
  depends_on = [ kubernetes_secret.grafana_admin_password, helm_release.prometheus ]
  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  version    = "6.60.1"
  namespace  = var.namespace

  values = [templatefile("${path.module}/grafana-values.yaml.tpl", {
    ingress_domain = var.ingress_domain
  })]
}

resource "kubernetes_secret" "grafana_admin_password" {
  metadata {
    name = "grafana-admin-password"
    namespace = var.namespace
  }

  data = {
    username = "admin"
    password = var.default_grafana_password
  }
}

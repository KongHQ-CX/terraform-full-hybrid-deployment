resource "helm_release" "jaeger" {
  name       = "jaeger"
  chart      = "jaeger"
  repository = "https://jaegertracing.github.io/helm-charts"
  version    = "0.71.0"
  namespace  = var.namespace

  values = [templatefile("${path.module}/values.yaml", {
    cassandra_cluster_size = var.cassandra_cluster_size
    collector_otlp_port = var.collector_otlp_port
    ingress_domain = var.ingress_domain
    headless_jaeger_service = var.headless_jaeger_service
  })]
}

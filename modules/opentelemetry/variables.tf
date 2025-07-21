variable "namespace" {
  description = "Namespace to install the license into"
  type = string
  default = "kong"
}

variable "ingress_domain" {
  description = "Ingress domain suffix (format .my.domain.tld) to apply to all ingress objects"
  type = string
  default = ".lh.kong-cx.com"
}

variable "cassandra_cluster_size" {
  description = "Replicas for the Cassandra backing store"
  type = number
  default = 1
}

variable "collector_otlp_port" {
  description = "Port to listen for OTLP HTTP(S) traffic"
  type = number
  default = 4318
}

variable "headless_jaeger_service" {
  description = "Set TRUE to make Jaeger a headless Kubernetes service"
  type = bool
  default = false
}

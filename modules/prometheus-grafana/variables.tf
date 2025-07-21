variable "namespace" {
  description = "Namespace to install Prometheus and Grafana into"
  type = string
  default = "prometheus"
}

variable "ingress_domain" {
  description = "Ingress domain suffix (format .my.domain.tld) to apply to all ingress objects"
  type = string
  default = ".lh.kong-cx.com"
}

variable "default_grafana_password" {
  description = "Default admin password for remotely accessing Grafana"
  type = string
  default = "password"
}

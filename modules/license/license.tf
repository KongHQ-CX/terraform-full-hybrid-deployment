resource "kubernetes_secret" "kong_enterprise_license" {
  count = var.is_konnect ? 0 : 1
  
  metadata {
    name = "kong-enterprise-license"
    namespace = var.namespace
  }

  data = {
    license = file(pathexpand(var.license_path))
  }
}

resource "kubernetes_config_map" "this" {
  metadata {
    name = "kong-plugin-${var.name}"
    namespace = var.namespace
  }

  data = {
    for f in fileset(var.directory, "*.lua") :
    f => file(join("/", [var.directory, f]))
  }
}


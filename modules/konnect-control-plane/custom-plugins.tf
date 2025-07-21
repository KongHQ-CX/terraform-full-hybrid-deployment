resource "konnect_gateway_custom_plugin_schema" "this" {
  count = var.custom_plugin_schemas != null ? length(var.custom_plugin_schemas) : 0
  lua_schema = file(var.custom_plugin_schemas[count.index])

  control_plane_id = konnect_gateway_control_plane.this.id
}

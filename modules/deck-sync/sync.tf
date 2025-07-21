// This module assumes that if "konnect_control_plane_name" is set, that it is always Konnect

resource "null_resource" "deck_sync_konnect" {
  count = var.konnect_control_plane_name != null ? 1 : 0

  provisioner "local-exec" {
    command = "deck ${var.konnect_region != null ? "--konnect-addr=https://${var.konnect_region}.api.konghq.com" : ""} ${var.konnect_token_file != null ? "--konnect-token-file=${pathexpand(var.konnect_token_file)}" : ""} ${var.konnect_control_plane_name != null ? "--konnect-control-plane-name=${var.konnect_control_plane_name}" : ""} gateway sync \"${pathexpand(var.deck_file)}\""
  }

  triggers = {
    deck_file_sha = filebase64sha512(pathexpand(var.deck_file))
  }
}

resource "null_resource" "deck_sync_enterprise" {
  count = var.kong_admin_url != null && var.konnect_control_plane_name == null ? 1 : 0

  provisioner "local-exec" {
    command = "deck --kong-addr=${var.kong_admin_url} --headers='kong-admin-token:${var.kong_admin_token}' gateway sync \"${pathexpand(var.deck_file)}\""
  }

  triggers = {
    deck_file_sha = filebase64sha512(pathexpand(var.deck_file))
  }
}

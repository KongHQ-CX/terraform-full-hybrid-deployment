output "kong_admin_url" {
    value = "https://kong-admin${var.ingress_domain}:443"
}

output "kong_admin_token" {
    value = var.kong_rbac_admin_password
}

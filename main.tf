module "kong" {
  count = 1
  depends_on = [
    module.license,
  ]

  source = "./modules/base-kong"
  kong_helm_chart_version = var.kong_helm_chart_version
  kong_values_template = var.kong_values_template

  namespace = var.namespace
  ingress_domain = var.ingress_domain
  ingress_vendor = var.ingress_vendor
  ingress_prefix = var.ingress_prefix
  kong_image_repository = var.kong_image_repository
  kong_image_tag = var.kong_image_tag
  kong_image_pull_policy = var.kong_image_pull_policy

  postgres_tag = var.postgres_tag
  use_database = var.use_database
  trusted_ip_cidr = var.trusted_ip_cidr

  ingress_annotations = var.ingress_annotations

  declarative_config_file = var.declarative_config_file
  kic_objects_file = var.kic_objects_file
  
  is_hybrid = var.is_hybrid
  kong_run_upgrade_migrations = var.kong_run_upgrade_migrations
  is_kic = var.is_kic
  kic_debug_mode = var.kic_debug_mode

  is_konnect = var.is_konnect
  konnect_cluster_host = (var.is_konnect && var.konnect_cluster_host == null) ? regex("^(?:(?P<scheme>[^:/?#]+):)?(?://(?P<authority>[^/?#]*))?", module.konnect_control_plane[0].control_plane_endpoint)["authority"] : var.konnect_cluster_host
  konnect_telemetry_host = (var.is_konnect && var.konnect_telemetry_host == null) ? regex("^(?:(?P<scheme>[^:/?#]+):)?(?://(?P<authority>[^/?#]*))?", module.konnect_control_plane[0].telemetry_endpoint)["authority"] : var.konnect_telemetry_host
  konnect_cluster_cert = (var.is_konnect && var.konnect_cluster_cert == null) ? module.konnect_control_plane[0].cluster_cert_pem : var.konnect_cluster_cert
  konnect_cluster_cert_key = (var.is_konnect && var.konnect_cluster_cert_key == null) ? module.konnect_control_plane[0].cluster_cert_key_pem : var.konnect_cluster_cert_key

  control_plane_deployment_name = var.control_plane_deployment_name
  data_plane_deployment_name = var.data_plane_deployment_name

  kong_vitals_enabled = var.kong_vitals_enabled
  debug_listen_enabled = var.debug_listen_enabled

  echo_server_file = var.echo_server_file
  echo_server_replicas = var.echo_server_replicas

  install_open_telemetry = var.install_open_telemetry
  install_hashicorp_vault = var.install_hashicorp_vault

  use_env_vault = var.use_env_vault

  cp_replicas = var.cp_replicas
  dp_replicas = var.dp_replicas
  replicas = var.replicas

  # KONG CONFIGURATION SHORTCUTS
  kong_config_log_level = var.kong_config_log_level
  kong_config_headers = var.kong_config_headers
  kong_config_untrusted_lua = var.kong_config_untrusted_lua
  kong_config_audit_log = var.kong_config_audit_log

  run_as_root = var.run_as_root

  install_cluster_issuing_ca = var.install_cluster_issuing_ca

  custom_plugins = var.custom_plugins
  kong_rbac_admin_password = var.kong_rbac_admin_password

  control_plane_custom_env = var.control_plane_custom_env
  data_plane_custom_env = var.data_plane_custom_env
}

module "konnect_control_plane" {
  source = "./modules/konnect-control-plane"
  count = (var.konnect_cluster_cert == null && var.is_konnect) ? 1 : 0

  name = var.konnect_control_plane_name
  custom_plugin_schemas = var.konnect_custom_plugin_schemas
}

module "custom_plugins" {
  depends_on = [ module.kong ]
  source = "./modules/custom-plugin"
  for_each = toset(var.custom_plugins)

  name      = each.value
  namespace = var.namespace
  directory = "custom-plugins/${each.value}"
}

module "deck_sync" {
  depends_on = [ module.kong ]
  count  = var.deck_file != null ? 1 : 0
  source = "./modules/deck-sync"
  
  deck_file = var.deck_file

  # Konnect Section
  konnect_region = var.konnect_region
  konnect_control_plane_name = var.konnect_control_plane_name
  konnect_token_file = var.konnect_token_file

  # Kong Hybrid Section
  kong_admin_url = module.kong[0].kong_admin_url
  kong_admin_token = module.kong[0].kong_admin_token
}

module "cluster_issuing_ca" {
  count = var.install_cluster_issuing_ca ? 1 : 0
  source = "./modules/cluster-issuing-ca"

  namespace = "cert-manager"
}

module "license" {
  source = "./modules/license"

  license_path = var.license_path
  namespace    = var.namespace
  is_konnect   = var.is_konnect
}

module "demo_certificate" {
  count = var.install_demo_certificate ? 1 : 0
  source = "./modules/demo-certificate"
  namespace = var.namespace
}

module "opentelemetry" {
  count = var.install_open_telemetry ? 1 : 0
  source = "./modules/opentelemetry"
  namespace = var.namespace
  ingress_domain = var.ingress_domain
  headless_jaeger_service = var.headless_jaeger_service
}

module "prometheus_grafana" {
  count = var.install_prometheus_grafana ? 1 : 0
  source = "./modules/prometheus-grafana"
  namespace = var.prometheus_grafana_namespace
  ingress_domain = var.ingress_domain
  default_grafana_password = var.default_grafana_password
}

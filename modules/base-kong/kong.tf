resource "helm_release" "kong" {
  count = var.is_konnect ? 0 : 1

  name            = var.control_plane_deployment_name
  chart           = "kong"
  repository      = "https://charts.konghq.com"
  version         = var.kong_helm_chart_version
  namespace       = var.namespace
  force_update    = var.force_update
  wait            = var.wait_for_helm
  wait_for_jobs   = var.wait_for_helm
  cleanup_on_fail = true

  values = [templatefile("${path.module}/${var.kong_values_template}", {
    kong_image_repository = var.kong_image_repository
    kong_image_tag = var.kong_image_tag
    kong_image_pull_policy = var.kong_image_pull_policy
    postgres_tag = var.postgres_tag
    use_database = var.is_hybrid ? true : var.use_database
    dbless_config = try(indent(4, file(var.declarative_config_file)), "")
    echo_server = (var.echo_server_file != null && (var.is_kic || var.is_hybrid || (!var.is_hybrid && !var.use_database))) ? templatefile("${path.module}/echo-servers/${var.echo_server_file}", { replicas = var.echo_server_replicas }) : ""
    untrusted_lua = var.kong_config_untrusted_lua
    is_hybrid = var.is_hybrid
    is_control_plane = var.is_hybrid ? true : false
    is_data_plane = false
    ingress_domain = var.ingress_domain
    release_id = var.control_plane_deployment_name
    install_open_telemetry = var.install_open_telemetry
    replicas = var.is_hybrid ? var.cp_replicas : var.replicas
    vaults = var.install_hashicorp_vault ? "hcv" : var.use_env_vault ? "env" : "off"
    log_level = var.kong_config_log_level
    vitals_enabled = var.kong_vitals_enabled
    is_konnect = var.is_konnect
    control_plane_deployment_name = var.control_plane_deployment_name
    data_plane_deployment_name = var.data_plane_deployment_name
    is_kic = var.is_kic
    kic_debug_mode = var.kic_debug_mode
    kic_extra_objects = var.kic_objects_file != null ? file(var.kic_objects_file) : ""
    konnect_cluster_host = var.konnect_cluster_host
    konnect_telemetry_host = var.konnect_telemetry_host
    custom_plugins = var.custom_plugins
    ingress_vendor = var.ingress_vendor
    ingress_prefix = var.ingress_prefix
    trusted_ip_cidr = var.trusted_ip_cidr
    extra_objects = var.extra_objects != null ? var.extra_objects : ""
    headers = var.kong_config_headers
    install_cluster_issuing_ca = var.install_cluster_issuing_ca
    kong_rbac_admin_password = var.kong_rbac_admin_password
    run_as_root = var.run_as_root
    kong_run_upgrade_migrations = var.kong_run_upgrade_migrations
    audit_log = var.kong_config_audit_log
    custom_env = var.control_plane_custom_env
    debug_listen_enabled = var.debug_listen_enabled
    ingress_annotations = var.ingress_annotations
  })]
}

resource "helm_release" "kong_data_plane" {
  count = ((var.is_hybrid || var.is_konnect) && (var.dp_replicas > 0)) ? 1 : 0
  
  name            = var.data_plane_deployment_name
  chart           = "kong"
  repository      = "https://charts.konghq.com"
  version         = var.kong_helm_chart_version
  namespace       = var.namespace
  force_update    = var.force_update
  wait            = var.wait_for_helm
  wait_for_jobs   = var.wait_for_helm
  cleanup_on_fail = true

  values = [templatefile("${path.module}/${var.kong_values_template}", {
    kong_image_repository = var.kong_image_repository
    kong_image_tag = var.kong_image_tag
    kong_image_pull_policy = var.kong_image_pull_policy
    postgres_tag = var.postgres_tag
    use_database = false
    dbless_config = try(indent(4, file(var.declarative_config_file)), "")
    echo_server = (var.echo_server_file != null && var.is_konnect) ? templatefile("${path.module}/echo-servers/${var.echo_server_file}", { replicas = var.echo_server_replicas }) : ""
    untrusted_lua = var.kong_config_untrusted_lua
    is_hybrid = var.is_hybrid
    is_control_plane = false
    is_data_plane = true
    ingress_domain = var.ingress_domain
    release_id = var.data_plane_deployment_name
    install_open_telemetry = var.install_open_telemetry
    replicas = var.dp_replicas
    vaults = var.install_hashicorp_vault ? "hcv" : var.use_env_vault ? "env" : "off"
    log_level = var.kong_config_log_level
    vitals_enabled = var.kong_vitals_enabled
    is_konnect = var.is_konnect
    control_plane_deployment_name = var.control_plane_deployment_name
    data_plane_deployment_name = var.data_plane_deployment_name
    is_kic = false
    kic_debug_mode = var.kic_debug_mode
    kic_extra_objects = ""
    konnect_cluster_host = var.konnect_cluster_host
    konnect_telemetry_host = var.konnect_telemetry_host
    custom_plugins = var.custom_plugins
    ingress_vendor = var.ingress_vendor
    ingress_prefix = var.ingress_prefix
    trusted_ip_cidr = var.trusted_ip_cidr
    extra_objects = var.extra_objects != null ? var.extra_objects : ""
    headers = var.kong_config_headers
    install_cluster_issuing_ca = var.install_cluster_issuing_ca
    kong_rbac_admin_password = null
    run_as_root = var.run_as_root
    kong_run_upgrade_migrations = var.kong_run_upgrade_migrations
    audit_log = var.kong_config_audit_log
    custom_env = var.data_plane_custom_env
    debug_listen_enabled = var.debug_listen_enabled
    ingress_annotations = var.ingress_annotations
  })]
}

resource "kubernetes_secret" "konnect_cluster_cert" {
  count = var.is_konnect ? 1 : 0

  metadata {
    name = "kong-cluster-cert-${var.data_plane_deployment_name}"
    namespace = var.namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = var.konnect_cluster_cert
    "tls.key" = var.konnect_cluster_cert_key
  }
}

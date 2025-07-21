ingress_domain = ".lh.kong-cx.com"
ingress_vendor = "traefik"
use_database = true
echo_server_file = "echo-return-body.yaml"
is_hybrid = true
install_demo_certificate = true

kong_image_tag = "3.11"

cp_replicas = 1
dp_replicas = 1

kong_vitals_enabled = false
wait_for_helm = false
namespace = "kong"

control_plane_deployment_name = "control-plane"
data_plane_deployment_name = "data-plane"

run_as_root = false
kong_run_upgrade_migrations = true

kong_config_log_level = "debug"

deck_file = "decks/echo-server-no-monitoring.yaml"

install_open_telemetry = false
install_prometheus_grafana = false

license_path = "./kong-license.json"

# control_plane_custom_env = {
#   "KONG_CLUSTER_INCREMENTAL_SYNC" = "on",
#   "KONG_CLUSTER_RPC" = "on"
# }
# data_plane_custom_env = {
#   "KONG_CLUSTER_INCREMENTAL_SYNC" = "on",
#   "KONG_CLUSTER_RPC" = "on"
# }

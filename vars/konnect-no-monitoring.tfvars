ingress_domain = ".lh.kong-cx.com"
ingress_vendor = "traefik"
echo_server_file = "echo-return-body.yaml"

is_hybrid = false
is_konnect = true
is_kic = false
use_database = false

install_demo_certificate = false

kong_image_tag = "3.11"

cp_replicas = 1
dp_replicas = 1

kong_vitals_enabled = false
wait_for_helm = false
namespace = "kong"

control_plane_deployment_name = "control-plane"
data_plane_deployment_name = "data-plane"

run_as_root = false
kong_run_upgrade_migrations = false

kong_config_log_level = "debug"

install_open_telemetry = false
install_prometheus_grafana = false

konnect_control_plane_name = "new-control-plane-1"
konnect_region = "eu"
konnect_token_file = "./konnect-pat.txt"
deck_file = "decks/echo-server-no-monitoring.yaml"

# control_plane_custom_env = {
#   "KONG_CLUSTER_INCREMENTAL_SYNC" = "on",
#   "KONG_CLUSTER_RPC" = "on"
# }
# data_plane_custom_env = {
#   "KONG_CLUSTER_INCREMENTAL_SYNC" = "on",
#   "KONG_CLUSTER_RPC" = "on"
# }

# konnect_custom_plugin_schemas = [
#   "~/kong-plugin-example/kong/plugins/example/schema.lua",
# ]

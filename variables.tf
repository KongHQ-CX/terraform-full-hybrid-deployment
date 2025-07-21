variable "kong_values_template" {
  description = "Values TFTPL file override for Kong Helm parameters."
  type = string
  default = "values.tftpl"
}

variable "kong_image_repository" {
  description = "Image repository to pull the Kong image from"
  type = string
  default = "kong/kong-gateway"
}

variable "kong_image_tag" {
  description = "Image tag to run Kong from"
  type = string
  default = "3.11"
}

variable "kong_image_pull_policy" {
  type = string
  default = "Always"
}

variable "debug_listen_enabled" {
  description = "Activates the debug port on the pod(s)"
  type = bool
  default = false
}

variable "postgres_tag" {
  description = "Image tag to run PostgreSQL from, if enabled"
  type = string
  default = "14.7.0-debian-11-r31"
}

variable "use_database" {
  description = "Whether or not, to initialise and use a postgres database for the Kong data store"
  type = bool
  default = true
}

variable "echo_server_file" {
  description = "Whether or not, to add a Kubernetes echo server deployment"
  type = string
  default = null
}

variable "echo_server_replicas" {
  description = "Number of echo server replica pods to run, if installed"
  type = number
  default = 1
}

variable "install_demo_certificate" {
  description = "Should I install the test certificate or have you provided your own secret name 'kong-cluster-cert'?"
  type = bool
  default = false
}

variable "install_cluster_issuing_ca" {
  description = "Should I install a Kubernetes CA for clustering certificates?"
  type = bool
  default = false
}

variable "install_open_telemetry" {
  description = "Installs the Jaeger all-in-one deployment, and configured Kong to use it for tracing data"
  type = bool
  default = false
}

variable "headless_jaeger_service" {
  description = "Set TRUE to make Jaeger a headless Kubernetes service"
  type = bool
  default = false
}

variable "install_redis_standalone" {
  description = "JACK: THIS DOESN'T DO ANYTHING!! Installs redis standalone instance, for rate limiting"
  type = bool
  default = false
}

variable "install_prometheus_grafana" {
  description = "Set `true` to install Prometheus AND Grafana for dashboarding, use https://github.com/KongHQ-CX/kong-custom-dashboards to generate decent dashboards"
  type        = bool
  default     = false
}

variable "prometheus_grafana_namespace" {
  description = "Namespace to install Prometheus AND Grafana into"
  type        = string
  default     = "prometheus"
}

variable "default_grafana_password" {
  description = "Default admin password for Grafana"
  type        = string
  default     = "password"
}

variable "install_localstack" { // TODO: not implemented??
  description = "Installs Localstack for fake AWS testing."
  type = bool
  default = false
}

variable "install_keycloak_cluster" {
  description = "Installs a Keycloak Cluster for fake OIDC testing."
  type = bool
  default = false
}

variable "install_keycloak_standalone" {
  description = "Installs a Keycloak standalone read-only deployment for fake OIDC testing."
  type = bool
  default = false
}

variable "keycloak_cluster_namespace" {
  description = "If `install_keycloak_cluster` is set, denotes which namespace to install Keycloak (and its DB) in to."
  type = string
  default = "keycloak"
}

variable "ingress_vendor" {
  description = "Vendor of the ingress controller / proxy in this Kube cluster; choices are 'traefik', 'nginx', 'aws-alb', 'aws-nlb'"
  type = string
  default = "traefik"
}

variable "ingress_prefix" {
  description = "Ingress URL prefixes"
  type = string
  default = "kong"
}

variable "trusted_ip_cidr" {
  description = "Comma-separated CIDR blocks to trust as a source of X-Forwarded-* headers, e.g. ingress proxy or load balancer."
  type = string
  default = "10.42.0.0/16"  // K3s on Alpine default
}

variable "run_as_root" {
  description = "When TRUE, the Kong container(s) run as root"
  type = bool
  default = false
}

variable "declarative_config_file" {
  description = "Declarative deck-format file to apply to Kong - works only if use_database is false"
  type = string
  default = null
}

variable "ingress_domain" {
  description = "Ingress domain suffix (format .my.domain.tld) to apply to all ingress objects"
  type = string
  default = ".lh.kong-cx.com"
}

variable "namespace" {
  description = "Namespace to install Kong into"
  type = string
  default = "kong"
}

variable "use_env_vault" {
  type = bool
  default = false
}

variable "license_path" {
  description = "Path to your enterprise license file"
  type = string
  default = "~/.license/kong.json"
}

variable "kong_config_headers" {
  description = "Server request/response fingerprinting headers"
  type = string
  default = "server_tokens, latency_tokens"
}

variable "kong_config_audit_log" {
  description = "Enabled audit logging into Postgres"
  type = string
  default = "off"
}

variable "kong_config_untrusted_lua" {
  type = string
  default = "sandbox"
}

variable "kong_config_log_level" {
  type = string
  default = "notice"
}

variable "install_hashicorp_vault" {
  type = bool
  default = false
}

variable "default_vault_token" {
  description = "Default root token for remotely accessing Vault secrets"
  type = string
  default = "root-token"
}

variable "replicas" {
  description = "Kong replicas to run - only applies if 'is_hybrid' is set to 'false'"
  type = number
  default = 1
}

variable "kong_vitals_enabled" {
  description = "Turn Kong Vitals on of off"
  type = bool
  default = false
}

variable "is_kic" {
  description = "Adds Kubernetes Ingress Controller if set to true"
  type = bool
  default = false
}

variable "kic_debug_mode" {
  description = "Set TRUE to put KIC into tracer/debug mode - opens the trace portal at :10256/debug/pprof/"
  type = bool
  default = false
}

variable "kic_objects_file" {
  description = "Path to a file containing an array of extra objects to apply to KIC, if enabled"
  type = string
  default = null
}

variable "custom_plugins" {
  description = "Array List of custom plugins to add (from ConfigMaps) and enable"
  type = list(string)
  default = []
}

variable "konnect_custom_plugin_schemas" {
  description = "List of Lua custom plugin 'schema,lua' files to upload to this Konnect control plane"
  type = list(string)
  default = null
}

variable "control_plane_custom_env" {
  description = "Custom environment variables to apply to the control plane"
  type = map(string)
  default = {}
}

variable "data_plane_custom_env" {
  description = "Custom environment variables to apply to the control plane"
  type = map(string)
  default = {}
}

/*
 * HYBRID KONG SECTION
 */
variable "is_hybrid" {
  description = "Defines a hybrid deployment, or traditional 'all-in-one' deployment"
  type = bool
  default = false
}

variable "kong_run_upgrade_migrations" {
  description = "Set true to run the preUpgrade and postUpgrade migration jobs - use only if updating the Kong image tag/version."
  type = bool
  default = false
}

variable "cp_replicas" {
  description = "Kong control-plane replicas to run - only applies if 'is_hybrid' is set to 'true'"
  type = number
  default = 1
}

variable "dp_replicas" {
  description = "Kong data-plane replicas to run - only applies if 'is_hybrid' is set to 'true'"
  type = number
  default = 1
}

variable "control_plane_deployment_name" {
  description = "Deployment name for this data plane set"
  type = string
  default = "kong-cp"
}

variable "data_plane_deployment_name" {
  description = "Deployment name for this data plane set"
  type = string
  default = "kong-dp"
}

variable "kong_rbac_admin_password" {
  description = "The default password for kong_admin, if using RBAC *and* basic-auth mode"
  type = string
  default = "K1ngK0ng"
}
//

/*
 * KONNECT SECTION
 */
variable "is_konnect" {
  description = "Defines whether this is an on-premise Kong Enterprise deployment, or a cloud Konnect deployment"
  type = bool
  default = false
}

variable "konnect_access_token" {
  description = "Konnect access token to use for this deployment"
  type = string
  default = null
}

variable "konnect_cluster_host" {
  description = "If is_konnect is true, set the Konnect Runtime Group clustering hostname here"
  type = string
  default = null
}

variable "konnect_telemetry_host" {
  description = "If is_konnect is true, set the Konnect Runtime Group telemetry hostname here"
  type = string
  default = null
}

variable "konnect_cluster_cert" {
  description = "Clustering certificate x509 PEM"
  type = string
  default = null
}

variable "konnect_cluster_cert_key" {
  description = "Clustering certificate private key PEM"
  type = string
  default = null
}
//

/*
 * APM Providers Section
 */
variable "install_datadog_agent" {
  description = "Performs a Helm installation of Datadog Agent if true - requires Datadog API and APP keys"
  type = bool
  default = false
}

variable "datadog_agent_namespace" {
  description = "If `install_datadog_agent` is true, defines the namespace to install Datadog agent into"
  type = string
  default = "datadog"
}

/*
 * Helm settings section
 */
variable "kong_helm_chart_version" {
  description = "Kong Helm Chart tag to install"
  type = string
  default = "2.51.0"
}

variable "force_update" {
  description = "Force replacement of Helm and other resources"
  type = bool
  default = false
}

variable "wait_for_helm" {
  description = "Set true to wait for Helm deployments to finish before returning to the shell"
  type = bool
  default = true
}
//

/*
 * Deck file sync section
 */

/*
 * KONNECT
 */
variable "konnect_region" {
  type = string
  default = null
}

variable "konnect_token_file" {
  type = string
  default = null
}

variable "konnect_control_plane_name" {
  type = string
  default = null
}

/*
 * Enterprise
 */
variable "kong_admin_url" {
  type = string
  default = null
}

variable "kong_admin_token" {
  type = string
  default = null
}

/*
 * SHARED
 */
variable "deck_file" {
  type = string
  default = null
}
//

variable "ingress_annotations" {
  description = "Annotations to apply to the Kong ingress(es)"
  type = map(string)
  default = {}
}
alertmanager:
  enabled: true
kubeStateMetrics:
  enabled: false
prometheus-node-exporter:
  enabled: false
prometheus-pushgateway:
  enabled: false

server:
  ingress:
    enabled: true
    hosts:
    - prometheus${ ingress_domain }
    paths: /
  persistentVolume:
    enabled: true
  global:
    ## How frequently to scrape targets by default - Kong requires 5s as it creates 5s export dimension widths
    scrape_interval: 5s
    ## How long until a scrape request times out
    scrape_timeout: 3s
  # List of flags to override default parameters, e.g:
  defaultFlagsOverride:
    - --storage.tsdb.retention.size=2GB
    - --config.file=/etc/config/prometheus.yml
    - --storage.tsdb.path=/data
    - --web.console.libraries=/etc/prometheus/console_libraries
    - --web.console.templates=/etc/prometheus/consoles
    - --web.enable-lifecycle

# # A scrape configuration for running Prometheus on a Kubernetes cluster.
# # This uses separate scrape configs for cluster components (i.e. API server, node)
# # and services to allow each to use different authentication configs.
# #
# # Kubernetes labels will be added as Prometheus labels on metrics via the
# # `labelmap` relabeling action.
# #
# # If you are using Kubernetes 1.7.2 or earlier, please take note of the comments
# # for the kubernetes-cadvisor job; you will need to edit or remove this job.

# # Scrape config for API servers.
# #
# # Kubernetes exposes API servers as endpoints to the default/kubernetes
# # service so this uses `endpoints` role and uses relabelling to only keep
# # the endpoints associated with the default/kubernetes service using the
# # default named port `https`. This works for single API server deployments as
# # well as HA API server deployments.


# scrape_configs:
#   # Example scrape config for pods
#   #
#   # The relabeling allows the actual pod scrape to be configured
#   # for all the declared ports (or port-free target if none is declared)
#   # or only some ports.
#   - job_name: "kubernetes-pods"

#     kubernetes_sd_configs:
#       - role: pod

#     relabel_configs:
#       # Example relabel to scrape only pods that have
#       # "example.io/should_be_scraped = true" annotation.
#       #  - source_labels: [__meta_kubernetes_pod_annotation_example_io_should_be_scraped]
#       #    action: keep
#       #    regex: true
#       #
#       # Example relabel to customize metric path based on pod
#       # "example.io/metric_path = <metric path>" annotation.
#       #  - source_labels: [__meta_kubernetes_pod_annotation_example_io_metric_path]
#       #    action: replace
#       #    target_label: __metrics_path__
#       #    regex: (.+)
#       #
#       # Example relabel to scrape only single, desired port for the pod
#       # based on pod "example.io/scrape_port = <port>" annotation.
#       #  - source_labels: [__address__, __meta_kubernetes_pod_annotation_example_io_scrape_port]
#       #    action: replace
#       #    regex: ([^:]+)(?::\d+)?;(\d+)
#       #    replacement: $1:$2
#       #    target_label: __address__
#       - action: labelmap
#         regex: __meta_kubernetes_pod_label_(.+)
#       - source_labels: [__meta_kubernetes_namespace]
#         action: replace
#         target_label: namespace
#       - source_labels: [__meta_kubernetes_pod_name]
#         action: replace
#         target_label: pod
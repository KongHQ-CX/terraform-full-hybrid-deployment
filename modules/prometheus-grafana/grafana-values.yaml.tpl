env:
  JAEGER_AGENT_PORT: "5775"

ingress:
  enabled: true
  hosts:
  - "grafana${ ingress_domain }"

admin:
  existingSecret: "grafana-admin-password"
  userKey: "username"
  passwordKey: "password"

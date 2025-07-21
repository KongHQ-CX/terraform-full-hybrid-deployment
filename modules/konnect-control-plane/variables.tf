variable "name" {
  description = "Universal name to apply to the control-plane, and its associated resources."
  type        = string
}

variable "custom_plugin_schemas" {
  description = "List of Lua custom plugin 'schema,lua' files to upload to this Konnect control plane"
  type = list(string)
  default = null
}

variable "konnect_access_token" {
  description = "Konnect access token to use for this deployment"
  type = string
  default = null
}

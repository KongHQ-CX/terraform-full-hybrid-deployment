variable "namespace" {
  description = "Namespace to install the license into"
  type = string
  default = "kong"
}

variable "license_path" {
  description = "Path to your enterprise license file"
  type = string
  default = "~/.license/kong.json"
}

variable "is_konnect" {
  description = "License isn't needed if this is a Konnect deployment"
  type = bool
  default = false
}

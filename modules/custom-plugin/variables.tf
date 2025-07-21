variable "name" {
  description = "Custom plugin name (should match the definition in schema.lua)"
  type = string
}

variable "directory" {
  description = "Directory containing all of the plugin files"
  type = string
}

variable "namespace" {
  description = "Namespace to install Kong into"
  type = string
  default = "kong"
}

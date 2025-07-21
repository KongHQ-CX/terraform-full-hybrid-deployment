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
}

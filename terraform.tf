terraform {
  // XTODO: Fill in your own state file storage
  backend "kubernetes" {
    secret_suffix  = "state"
    config_path    = "~/.kube/config"
    config_context = "colima"
  }

  // XTODO: Keep this up to date with the latest version of the provider
  //        to ensure compatibility with Konnect APIs.
  required_providers {
    konnect = {
      source  = "kong/konnect"
      version = "2.11.1"
    }
  }
}

provider "helm" {}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

provider "konnect" {
  konnect_access_token = "${trimspace(file(var.konnect_token_file))}"
  server_url           = "https://${var.konnect_region}.api.konghq.com"
}

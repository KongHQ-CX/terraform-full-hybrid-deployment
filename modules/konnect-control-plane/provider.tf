terraform {
  // XTODO: Keep this up to date with the latest version of the provider
  //        to ensure compatibility with Konnect APIs.
  required_providers {
    konnect = {
      source  = "kong/konnect"
      version = "2.11.1"
    }
  }
}

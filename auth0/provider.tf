terraform {
  required_version = ">= 1.7.0"

  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.12.0" # Refer to docs for latest version
    }
    ## Add other providers here
  }
}

provider "auth0" {
  debug         = false
}
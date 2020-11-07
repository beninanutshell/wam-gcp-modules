terraform {
  required_version = ">=0.12.20, <0.14"

  required_providers {
    google      = "~> 3.9"
    google-beta = "~> 3.9"
    null        = "~> 2.1"
    random      = "~> 2.2"
  }
}
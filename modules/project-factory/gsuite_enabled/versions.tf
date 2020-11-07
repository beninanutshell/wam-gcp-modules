terraform {
  required_version = ">=0.12.20, <0.14"

  required_providers {
    google      = "~> 3.9"
    google-beta = "~> 3.9"
    gsuite      = "~> 0.1"
  }
}
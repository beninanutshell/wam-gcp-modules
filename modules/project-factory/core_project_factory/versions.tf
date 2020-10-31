terraform {
  required_version = ">=0.12.6, <0.14"

  required_providers {
    google      = ">= 3.8, < 4.0"
    google-beta = ">= 3.8, < 4.0"
    null        = "~> 2.1"
    random      = "~> 2.2"
  }
}

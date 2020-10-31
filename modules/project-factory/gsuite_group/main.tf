/******************************************
  Locals configuration
 *****************************************/

locals {
  domain_list = concat(data.google_organization.org.*.domain, ["dummy"])
  domain      = var.domain == "" ? element(local.domain_list, 0) : var.domain
  email       = var.name == "" ? "" : format("%s@%s", var.name, local.domain)
}

/*****************************************
  Organization info retrieval
 *****************************************/

data "google_organization" "org" {
  count        = var.domain == "" && var.name != "" ? 1 : 0
  organization = var.org_id
}


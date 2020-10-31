/******************************************
  Locals configuration
 *****************************************/

locals {
  services = var.enable_apis ? toset(concat(var.activate_apis, [for i in var.activate_api_identities : i.api])) : toset([])
  service_identities = flatten([
    for i in var.activate_api_identities : [
      for r in i.roles :
      { api = i.api, role = r }
    ]
  ])
}

/******************************************
  APIs configuration
 *****************************************/

resource "google_project_service" "project_services" {
  for_each                   = local.services
  project                    = var.project_id
  service                    = each.value
  disable_on_destroy         = var.disable_services_on_destroy
  disable_dependent_services = var.disable_dependent_services
}

resource "google_project_service_identity" "project_service_identities" {
  for_each = {
    for i in var.activate_api_identities :
    i.api => i
  }

  provider = google-beta
  project  = var.project_id
  service  = each.value.api
}

resource "google_project_iam_member" "project_service_identity_roles" {
  for_each = {
    for si in local.service_identities :
    "${si.api} ${si.role}" => si
  }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_project_service_identity.project_service_identities[each.value.api].email}"
}

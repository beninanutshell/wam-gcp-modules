/******************************************
  Locals configuration
 *****************************************/

locals {
  cloudsvc_service_account = "${google_project.project.number}@cloudservices.gserviceaccount.com"
  all_oslogin_users        = concat(var.oslogin_users, var.oslogin_admins)
  num_oslogin_users        = length(var.oslogin_users) + length(var.oslogin_admins)
  gce_service_account      = "${google_project.project.number}-compute@developer.gserviceaccount.com"
  gke_service_account      = "service-${google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
  parent_type              = split("/", var.parent)[0]
  parent_id                = split("/", var.parent)[1]
}

resource "google_project" "project" {
  org_id              = local.parent_type == "organizations" ? local.parent_id : ""
  folder_id           = local.parent_type == "folders" ? local.parent_id : ""
  project_id          = "${var.prefix}-${var.name}"
  name                = "${var.prefix}-${var.name}"
  billing_account     = var.billing_account
  auto_create_network = var.auto_create_network
  labels              = var.labels
}

resource "google_project_service" "project_services" {
  for_each                   = toset(var.activate_apis)
  project                    = google_project.project.project_id
  service                    = each.value
  disable_on_destroy         = true
  disable_dependent_services = true
}

/******************************************
  IAM members configuration
 *****************************************/

resource "google_project_iam_member" "owners" {
  count   = length(var.owners)
  project = google_project.project.project_id
  role    = "roles/owner"
  member  = element(var.owners, count.index)
}

resource "google_project_iam_member" "editors" {
  count   = length(var.editors)
  project = google_project.project.project_id
  role    = "roles/editor"
  member  = element(var.editors, count.index)
}

resource "google_project_iam_member" "viewers" {
  count   = length(var.viewers)
  project = google_project.project.project_id
  role    = "roles/viewer"
  member  = element(var.viewers, count.index)
}

resource "google_compute_project_metadata_item" "oslogin_meta" {
  count   = var.oslogin ? 1 : 0
  project = google_project.project.project_id
  key     = "enable-oslogin"
  value   = "TRUE"

  # depend on services or it will fail on destroy
  depends_on = [google_project_service.project_services]
}

resource "google_project_iam_member" "oslogin_admins" {
  count   = var.oslogin ? length(var.oslogin_admins) : 0
  project = google_project.project.project_id
  role    = "roles/compute.osAdminLogin"
  member  = element(var.oslogin_admins, count.index)
}

resource "google_project_iam_member" "oslogin_users" {
  count   = var.oslogin ? length(var.oslogin_users) : 0
  project = google_project.project.project_id
  role    = "roles/compute.osLogin"
  member  = element(var.oslogin_users, count.index)
}

resource "google_project_iam_member" "oslogin_sa_users" {
  count   = var.oslogin ? local.num_oslogin_users : 0
  project = google_project.project.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = element(local.all_oslogin_users, count.index)
}

# this grants the project viewer role to OS Login users, so that they can
# use the CLI to get the list of instances
resource "google_project_iam_member" "oslogin_viewers" {
  count   = var.oslogin ? local.num_oslogin_users : 0
  project = google_project.project.project_id
  role    = "roles/viewer"
  member  = element(local.all_oslogin_users, count.index)
}

resource "google_project_iam_custom_role" "roles" {
  count       = length(var.custom_roles)
  project     = google_project.project.project_id
  role_id     = element(keys(var.custom_roles), count.index)
  title       = "Custom role ${element(keys(var.custom_roles), count.index)}"
  description = "Terraform-managed"

  permissions = split(",", element(values(var.custom_roles), count.index))
}

resource "google_project_iam_binding" "extra" {
  count      = length(var.extra_bindings_roles)
  project    = google_project.project.project_id
  role       = element(var.extra_bindings_roles, count.index)
  members    = split(",", element(var.extra_bindings_members, count.index))
  depends_on = [google_project_iam_custom_role.roles]
}

resource "google_resource_manager_lien" "lien" {
  count        = var.lien_reason != "" ? 1 : 0
  parent       = "projects/${google_project.project.number}"
  restrictions = ["resourcemanager.projects.delete"]
  origin       = "created-by-terraform"
  reason       = var.lien_reason
}

resource "google_project_iam_member" "gce_service_account" {
  count = length(var.gce_service_account_roles)
  project = element(
    split("=>", element(var.gce_service_account_roles, count.index)),
    0,
  )
  role = element(
    split("=>", element(var.gce_service_account_roles, count.index)),
    1,
  )
  member = "serviceAccount:${local.gce_service_account}"
}


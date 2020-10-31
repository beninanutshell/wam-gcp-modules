output "project_id" {
  description = "Project id (depends on services)."
  value       = google_project.project.project_id
  depends_on  = [google_project_service.project_services]
}

output "name" {
  description = "Name (depends on services)."
  value       = google_project.project.name
  depends_on  = [google_project_service.project_services]
}

output "number" {
  description = "Project number (depends on services)."
  value       = google_project.project.number
  depends_on  = [google_project_service.project_services]
}

output "cloudsvc_service_account" {
  description = "Cloud services service account (depends on services)."
  value       = "${local.cloudsvc_service_account}"
  depends_on  = [google_project_service.project_services]
}

output "gce_service_account" {
  description = "Default GCE service account (depends on services)."
  value       = local.gce_service_account
  depends_on  = [google_project_service.project_services]
}

output "gke_service_account" {
  description = "Default GKE service account (depends on services)."
  value       = local.gke_service_account
  depends_on  = [google_project_service.project_services]
}

output "custom_roles" {
  description = "Ids of the created custom roles."
  value       = google_project_iam_custom_role.roles[*].role_id
}


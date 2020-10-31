output "project_name" {
  value = google_project.main.name
}

output "project_id" {
  value = element(
    concat(
      [module.project_services.project_id],
      [google_project.main.project_id],
      [var.enable_shared_vpc_service_project ? google_compute_shared_vpc_service_project.shared_vpc_attachment[0].id : ""],
      [var.enable_shared_vpc_host_project ? google_compute_shared_vpc_host_project.shared_vpc_host[0].id : ""],
    ),
    0,
  )
  depends_on = [module.project_services]
}

output "project_number" {
  value      = google_project.main.number
  depends_on = [module.project_services]
}

output "service_account_id" {
  value       = google_service_account.default_service_account.account_id
  description = "The id of the default service account"
}

output "service_account_display_name" {
  value       = google_service_account.default_service_account.display_name
  description = "The display name of the default service account"
}

output "service_account_email" {
  value       = google_service_account.default_service_account.email
  description = "The email of the default service account"
}

output "service_account_name" {
  value       = google_service_account.default_service_account.name
  description = "The fully-qualified name of the default service account"
}

output "service_account_unique_id" {
  value       = google_service_account.default_service_account.unique_id
  description = "The unique id of the default service account"
}

output "project_bucket_name" {
  description = "The name of the projec's bucket"
  value       = google_storage_bucket.project_bucket.*.name
}

output "project_bucket_self_link" {
  value       = google_storage_bucket.project_bucket.*.self_link
  description = "Project's bucket selfLink"
}

output "project_bucket_url" {
  value       = google_storage_bucket.project_bucket.*.url
  description = "Project's bucket url"
}

output "api_s_account" {
  value       = local.api_s_account
  description = "API service account email"
}

output "api_s_account_fmt" {
  value       = local.api_s_account_fmt
  description = "API service account email formatted for terraform use"
}

output "enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.project_services.enabled_apis
}

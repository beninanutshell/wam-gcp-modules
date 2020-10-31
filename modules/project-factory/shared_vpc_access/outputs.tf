output "active_api_service_accounts" {
  description = "List of active API service accounts in the service project."
  value       = local.active_apis
}

output "project_id" {
  description = "Service project ID."
  value       = var.service_project_id
  depends_on = [
    google_compute_subnetwork_iam_member.service_shared_vpc_subnet_users,
    google_project_iam_member.gke_host_agent,
    google_project_iam_member.service_shared_vpc_user,
  ]
}

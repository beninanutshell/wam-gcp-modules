output "cloudbuild_project_id" {
  description = "Project where CloudBuild configuration and terraform container image will reside."
  value       = module.cloudbuild_project.project_id
}

output "gcs_bucket_cloudbuild_artifacts" {
  description = "Bucket used to store Cloud/Build artefacts in CloudBuild project."
  value       = google_storage_bucket.cloudbuild_artifacts.name
}

output "csr_repos" {
  description = "List of Cloud Source Repos created by the module, linked to Cloud Build triggers."
  value       = google_sourcerepo_repository.gcp_repo
}

output "kms_keyring" {
  description = "KMS Keyring created by the module."
  value       = google_kms_key_ring.org_bootstrap_kr
}

output "kms_crypto_key" {
  description = "KMS key created by the module."
  value       = google_kms_crypto_key.org_bootstrap_key
}

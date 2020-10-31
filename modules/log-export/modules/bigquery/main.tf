#-----------------#
# Local variables #
#-----------------#

locals {
  dataset_name = element(
    concat(google_bigquery_dataset.dataset.*.dataset_id, [""]),
    0,
  )
  destination_uri = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${local.dataset_name}"
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = var.project_id
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

#------------------#
# Bigquery dataset #
#------------------#
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_name
  project                     = google_project_service.enable_destination_api.project
  location                    = var.location
  description                 = var.description
  delete_contents_on_destroy  = var.delete_contents_on_destroy
  default_table_expiration_ms = var.expiration_days == null ? null : var.expiration_days * 8.64 * pow(10, 7)
  labels                      = var.labels
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_project_iam_member" "bigquery_sink_member" {
  project = google_bigquery_dataset.dataset.project
  role    = "roles/bigquery.dataEditor"
  member  = var.log_sink_writer_identity
}

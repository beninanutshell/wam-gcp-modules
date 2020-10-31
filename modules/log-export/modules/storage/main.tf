#-----------------#
# Local variables #
#-----------------#
locals {
  storage_bucket_name = element(concat(google_storage_bucket.bucket.*.name, [""]), 0)
  destination_uri     = "storage.googleapis.com/${local.storage_bucket_name}"
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = var.project_id
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}

#----------------#
# Storage bucket #
#----------------#
resource "google_storage_bucket" "bucket" {
  name                        = var.storage_bucket_name
  project                     = google_project_service.enable_destination_api.project
  storage_class               = var.storage_class
  location                    = var.location
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = var.uniform_bucket_level_access

  dynamic "lifecycle_rule" {
    for_each = var.expiration_days == null ? [] : [var.expiration_days]
    content {
      action {
        type = "Delete"
      }
      condition {
        age        = var.expiration_days
        with_state = "ANY"
      }
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [var.retention_policy]
    content {
      is_locked        = var.retention_policy.is_locked
      retention_period = var.retention_policy.retention_period_days * 24 * 60 * 60 // days to seconds
    }
  }
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_storage_bucket_iam_member" "storage_sink_member" {
  bucket = local.storage_bucket_name
  role   = "roles/storage.objectCreator"
  member = var.log_sink_writer_identity
}

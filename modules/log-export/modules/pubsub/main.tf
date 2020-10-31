#-----------------#
# Local variables #
#-----------------#
locals {
  destination_uri = "pubsub.googleapis.com/projects/${var.project_id}/topics/${local.topic_name}"
  topic_name      = element(concat(google_pubsub_topic.topic.*.name, [""]), 0)
  pubsub_subscriber = element(
    concat(google_service_account.pubsub_subscriber.*.email, [""]),
    0,
  )
  pubsub_subscription = element(
    concat(google_pubsub_subscription.pubsub_subscription.*.id, [""]),
    0,
  )
  pubsub_push_subscription = element(
    concat(google_pubsub_subscription.pubsub_push_subscription.*.id, [""]),
    0,
  )
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = var.project_id
  service            = "pubsub.googleapis.com"
  disable_on_destroy = false
}

#--------------#
# Pubsub topic #
#--------------#
resource "google_pubsub_topic" "topic" {
  name    = var.topic_name
  project = google_project_service.enable_destination_api.project
  labels  = var.topic_labels
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_pubsub_topic_iam_member" "pubsub_sink_member" {
  project = var.project_id
  topic   = local.topic_name
  role    = "roles/pubsub.publisher"
  member  = var.log_sink_writer_identity
}

#-----------------------------------------------#
# Pub/Sub topic subscription (for integrations) #
#-----------------------------------------------#
resource "google_service_account" "pubsub_subscriber" {
  count        = var.create_subscriber ? 1 : 0
  account_id   = "${local.topic_name}-subscriber"
  display_name = "${local.topic_name} Topic Subscriber"
  project      = var.project_id
}

resource "google_pubsub_topic_iam_member" "pubsub_subscriber_role" {
  count   = var.create_subscriber ? 1 : 0
  role    = "roles/pubsub.subscriber"
  project = var.project_id
  topic   = local.topic_name
  member  = "serviceAccount:${google_service_account.pubsub_subscriber[0].email}"
}

resource "google_pubsub_topic_iam_member" "pubsub_viewer_role" {
  count   = var.create_subscriber ? 1 : 0
  role    = "roles/pubsub.viewer"
  project = var.project_id
  topic   = local.topic_name
  member  = "serviceAccount:${google_service_account.pubsub_subscriber[0].email}"
}

resource "google_pubsub_subscription" "pubsub_subscription" {
  count   = var.create_subscriber ? 1 : 0
  name    = "${local.topic_name}-subscription"
  project = var.project_id
  topic   = local.topic_name
}

resource "google_pubsub_subscription" "pubsub_push_subscription" {
  count   = var.create_push_subscriber ? 1 : 0
  name    = "${local.topic_name}-push-subscription"
  project = var.project_id
  topic   = local.topic_name

  push_config {
    push_endpoint = var.push_endpoint
  }
}
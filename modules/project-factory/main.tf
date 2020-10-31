
/*****************************************
  Organization info retrieval
 *****************************************/
module "gsuite_group" {
  source = "./gsuite_group"

  domain = var.domain
  name   = var.group_name
  org_id = var.org_id
}

module "project-factory" {
  source = "./core_project_factory"

  group_email                        = module.gsuite_group.email
  group_role                         = var.group_role
  lien                               = var.lien
  manage_group                       = var.group_name != "" ? "true" : "false"
  random_project_id                  = var.random_project_id
  org_id                             = var.org_id
  name                               = var.name
  project_id                         = var.project_id
  shared_vpc                         = var.shared_vpc
  enable_shared_vpc_service_project  = var.shared_vpc != ""
  enable_shared_vpc_host_project     = var.enable_shared_vpc_host_project
  billing_account                    = var.billing_account
  folder_id                          = var.folder_id
  sa_role                            = var.sa_role
  activate_apis                      = var.activate_apis
  activate_api_identities            = var.activate_api_identities
  usage_bucket_name                  = var.usage_bucket_name
  usage_bucket_prefix                = var.usage_bucket_prefix
  credentials_path                   = var.credentials_path
  impersonate_service_account        = var.impersonate_service_account
  shared_vpc_subnets                 = var.shared_vpc_subnets
  labels                             = var.labels
  bucket_project                     = var.bucket_project
  bucket_name                        = var.bucket_name
  bucket_location                    = var.bucket_location
  bucket_versioning                  = var.bucket_versioning
  auto_create_network                = var.auto_create_network
  disable_services_on_destroy        = var.disable_services_on_destroy
  default_service_account            = var.default_service_account
  disable_dependent_services         = var.disable_dependent_services
  use_tf_google_credentials_env_var  = var.use_tf_google_credentials_env_var
  skip_gcloud_download               = var.skip_gcloud_download
  vpc_service_control_attach_enabled = var.vpc_service_control_attach_enabled
  vpc_service_control_perimeter_name = var.vpc_service_control_perimeter_name
}

/******************************************
  Billing budget to create if amount is set
 *****************************************/
module "budget" {
  source        = "./budget"
  create_budget = var.budget_amount != null

  projects                         = [module.project-factory.project_id]
  billing_account                  = var.billing_account
  amount                           = var.budget_amount
  alert_spent_percents             = var.budget_alert_spent_percents
  alert_pubsub_topic               = var.budget_alert_pubsub_topic
  monitoring_notification_channels = var.budget_monitoring_notification_channels
}

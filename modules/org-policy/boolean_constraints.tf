/******************************************
  Organization policy (boolean constraint)
 *****************************************/
resource "google_organization_policy" "org_policy_boolean" {
  count = local.organization && local.boolean_policy ? 1 : 0

  org_id     = var.organization_id
  constraint = var.constraint

  boolean_policy {
    enforced = var.enforce != false
  }
}

/******************************************
  Folder policy (boolean constraint)
 *****************************************/
resource "google_folder_organization_policy" "folder_policy_boolean" {
  count = local.folder && local.boolean_policy ? 1 : 0

  folder     = var.folder_id
  constraint = var.constraint

  boolean_policy {
    enforced = var.enforce != false
  }
}

/******************************************
  Project policy (boolean constraint)
 *****************************************/
resource "google_project_organization_policy" "project_policy_boolean" {
  count = local.project && local.boolean_policy ? 1 : 0

  project    = var.project_id
  constraint = var.constraint

  boolean_policy {
    enforced = var.enforce != false
  }
}

/******************************************
  Exclude folders from policy (boolean constraint)
 *****************************************/
resource "google_folder_organization_policy" "policy_boolean_exclude_folders" {
  for_each = (local.boolean_policy && ! local.project) ? var.exclude_folders : []

  folder     = each.value
  constraint = var.constraint

  boolean_policy {
    enforced = var.enforce == false
  }
}

/******************************************
  Exclude projects from policy (boolean constraint)
 *****************************************/
resource "google_project_organization_policy" "policy_boolean_exclude_projects" {
  for_each = (local.boolean_policy && ! local.project) ? var.exclude_projects : []

  project    = each.value
  constraint = var.constraint

  boolean_policy {
    enforced = var.enforce == false
  }
}

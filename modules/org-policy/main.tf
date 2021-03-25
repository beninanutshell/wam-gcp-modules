/******************************************
  Locals configuration for module logic
 *****************************************/
locals {
  organization   = var.policy_for == "organization"
  folder         = var.policy_for == "folder"
  project        = var.policy_for == "project"
  boolean_policy = var.policy_type == "boolean"
  list_policy    = var.policy_type == "list" && !local.invalid_config

  // If allow/deny list empty and enforce is not set, enforce is set to true
  enforce               = var.allow_list_length > 0 || var.deny_list_length > 0 ? null : var.enforce != false
  invalid_config_case_1 = var.deny_list_length > 0 && var.allow_list_length > 0

  // We use var.enforce here because allow/deny lists can not be used together with enforce flag
  invalid_config_case_2 = var.allow_list_length + var.deny_list_length > 0 && var.enforce != null
  invalid_config        = var.policy_type == "list" && local.invalid_config_case_1 || local.invalid_config_case_2
}

/******************************************
  Checks a valid configuration for list constraint
 *****************************************/
resource "null_resource" "config_check" {
  /*
    This resource shows the user a message intentionally
    If user sets two (or more) of following variables when policy type is "list":
    - allow
    - deny
    - enforce ("true" or "false")
    the configuration is invalid and the message below is shown
  */
  count = local.invalid_config ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'For list constraints only one of enforce, allow, and deny may be included.'; false"
  }
}

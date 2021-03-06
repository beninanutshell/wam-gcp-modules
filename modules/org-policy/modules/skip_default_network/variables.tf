variable "policy_for" {
  description = "Resource hierarchy node to apply the policy to: can be one of `organization`, `folder`, or `project`."
  type        = string
}

variable "organization_id" {
  description = "The organization id for putting the policy"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The folder id for putting the policy"
  type        = string
  default     = null
}

variable "project_id" {
  description = "The project id for putting the policy"
  type        = string
  default     = null
}

variable "exclude_folders" {
  description = "List of folders to exclude from the policy"
  type        = list(string)
  default     = [""]
}

variable "exclude_projects" {
  description = "List of projects to exclude from the policy"
  type        = list(string)
  default     = [""]
}

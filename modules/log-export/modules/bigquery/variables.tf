variable "dataset_name" {
  description = "The name of the bigquery dataset to be created and used for log entries matching the filter."
  type        = string
}

variable "log_sink_writer_identity" {
  description = "The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module)."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the bigquery dataset will be created."
  type        = string
}

variable "location" {
  description = "The location of the storage bucket."
  type        = string
  default     = "EU"
}

variable "delete_contents_on_destroy" {
  description = "(Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = false
}

variable "expiration_days" {
  description = "Table expiration time. If unset logs will never be deleted."
  type        = number
  default     = null
}

variable "description" {
  description = "A use-friendly description of the dataset"
  type        = string
  default     = "Log export dataset"
}

variable "labels" {
  description = "Dataset labels"
  type        = map(string)
  default     = {}
}

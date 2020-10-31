variable "log_sink_writer_identity" {
  description = "The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module)."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the storage bucket will be created."
  type        = string
}

variable "storage_bucket_name" {
  description = "The name of the storage bucket to be created and used for log entries matching the filter."
  type        = string
}

variable "location" {
  description = "The location of the storage bucket."
  type        = string
  default     = "EU"
}

variable "storage_class" {
  description = "The storage class of the storage bucket."
  type        = string
  default     = "STANDARD"
}

variable "uniform_bucket_level_access" {
  description = "Enables Uniform bucket-level access access to a bucket."
  type        = bool
  default     = true
}

variable "expiration_days" {
  description = "Object expiration time. If unset logs will never be deleted."
  type        = number
  default     = null
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects."
  type        = bool
  default     = false
}

variable "retention_policy" {
  description = "Configuration of the bucket's data retention policy for how long objects in the bucket should be retained."
  type = object({
    is_locked             = bool
    retention_period_days = number
  })
  default = null
}

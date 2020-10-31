variable "host_project_id" {
  description = "The ID of the host project which hosts the shared VPC"
  type        = string
}

variable "service_project_id" {
  description = "The ID of the service project"
  type        = string
}

variable "shared_vpc_subnets" {
  description = "List of subnets fully qualified subnet IDs (ie. projects/$project_id/regions/$region/subnetworks/$subnet_id)"
  type        = list(string)
  default     = []
}

variable "active_apis" {
  description = "The list of active apis on the service project. If api is not active this module will not try to activate it"
  type        = list(string)
  default     = []
}

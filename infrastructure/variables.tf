# Service variables
variable "logical_env" {
  description = "the logical environment name ex: dev, staging, prod, etc."
  type        = string
}

variable "business_env" {
  description = "the name of the business env ex: b2c, compass, etc."
  type        = string
}

variable "service_name" {
  type        = string
  description = "Service name"
}

variable "run_tag" {
  type        = string
  description = "Run tag of the current CI build e.g the docker image version"
  default     = "latest"
}


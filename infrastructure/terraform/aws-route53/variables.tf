variable "create_zone" {
  description = "A boolean flag to determine whether to create Host Zone in Route53"
  type        = bool
  default     = true
}

variable "zones" {
  description = "Map of Route53 zone parameters"
  type        = any
  default     = {}
}

variable "create_record" {
  description = "A boolean flag to determine whether to create DNS records in Route53"
  type        = bool
  default     = true
}

variable "records" {
  description = "List of maps of DNS records"
  type        = any
  default     = []
}

################################################################################
# Common Variables
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS Region name to deploy resources."
  type        = string
  default     = "ap-southeast-1"
}

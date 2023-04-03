variable "create_certificate" {
  description = "Whether to create ACM certificate"
  type        = bool
  default     = true
}

variable "validate_certificate" {
  description = "Whether to validate certificate by creating Route53 record"
  type        = bool
  default     = true
}

variable "validation_allow_overwrite_records" {
  description = "Whether to allow overwrite of Route53 records"
  type        = bool
  default     = true
}

variable "wait_for_validation" {
  description = "Whether to wait for the validation to complete"
  type        = bool
  default     = true
}

variable "domain" {
  description = <<-EOT
    List domain name for which the certificate should be issued. Map should contain.
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
    {
    "uat.com.vn" = {
      domain_name   = "uat.com.vn"
      zone_id       = "1234567"
      validation_method = "DNS"
      certificate_transparency_logging_preference = true
      subject_alternative_names = [
        "uat.com.vn",
        "*.uat.com.vn",
      ]
      ttl = 60
      tags = {}
    }
  EOT
  type        = any
  default     = null
}

variable "create_route53_records" {
  description = "When validation is set to DNS, define whether to create the DNS records internally via Route53 or externally using any DNS provider"
  type        = bool
  default     = true
}

variable "validation_record_fqdns" {
  description = "When validation is set to DNS and the DNS validation records are set externally, provide the fqdns for the validation"
  type        = list(string)
  default     = []
}

################################################################################
# Common Variables
################################################################################

variable "master_prefix" {
  default     = "dso"
  description = "To specify a key prefix for aws resource"
  type        = string
}

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

variable "route53_assume_role" {
  description = "AssumeRole to manage the resources within account containing route53."
  type        = string
  default     = null
}

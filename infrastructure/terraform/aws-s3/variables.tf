################################################################################
# S3 Variables
################################################################################
variable "create_s3" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether to create S3 bucket"
  validation {
    condition     = contains([true, false], var.create_s3)
    error_message = "Valid values for var: create_s3 are `true`, `false`."
  }
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = null
}

variable "s3_bucket_override_name" {
  description = "The override name of the S3 bucket"
  type        = string
  default     = null
}

variable "s3_kms_key_arn" {
  description = "The ARN of the KMS CMK to use for encryption"
  default     = null
  type        = string
}

variable "s3_sse_algorithm" {
  type        = string
  description = "The server-side encryption algorithm to use"
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.s3_sse_algorithm)
    error_message = "Valid values for var: s3_sse_algorithm are `AES256 `, `aws:kms`."
  }
}

variable "s3_lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}

variable "s3_force_destroy" {
  default     = false
  type        = bool
  description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error."
  validation {
    condition     = contains([true, false], var.s3_force_destroy)
    error_message = "Valid values for var: s3_force_destroy are `true`, `false`."
  }
}

variable "s3_versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  default     = {}
}

variable "s3_expected_bucket_owner" {
  description = "The account ID of the expected bucket owner"
  type        = string
  default     = null
}

variable "s3_cors_rule" {
  description = "List of maps containing rules for Cross-Origin Resource Sharing."
  type        = any
  default     = []
}

variable "s3_server_access_logging" {
  type        = map(string)
  default     = {}
  description = "Map containing access bucket logging configuration."
}

variable "s3_acl" {
  type        = string
  default     = "log-delivery-write"
  description = "ACL to apply to the S3 bucket"
  validation {
    condition     = contains(["private", "public-read", "public-read-write", "aws-exec-read", "authenticated-read", "log-delivery-write"], var.s3_acl)
    error_message = "Valid values for var: s3_acl are `private`, `public-read`, `public-read-write`, `aws-exec-read`, `authenticated-read`, `log-delivery-write`."
  }
}

variable "s3_policy" {
  type        = string
  default     = null
  description = "A valid bucket policy JSON document"
}

variable "s3_public_access_block" {
  default = {
    block_public_acls       = true
    block_public_policy     = true
    restrict_public_buckets = true
    ignore_public_acls      = true
  }
  description = "Manages S3 account-level Public Access Block configuration. For more information about these settings, see the AWS S3 Block Public Access documentation."
  type        = map(string)
}

variable "s3_tags" {
  description = "Additional tags for S3 bucket"
  type        = map(string)
  default     = {}
}

variable "s3_object_lock_enabled" {
  description = "Whether S3 bucket should have an Object Lock configuration enabled."
  type        = bool
  default     = false
  validation {
    condition     = contains([true, false], var.s3_object_lock_enabled)
    error_message = "Valid values for var: s3_object_lock_enabled are `true`, `false`."
  }
}

variable "s3_bucket_key_enabled" {
  description = "Whether to use bucket key enabled to save cost"
  type        = bool
  default     = false
}

variable "accelerate_configuration" {
  description = "Whether S3 bucket should have an Object Lock configuration enabled."
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Suspended"], var.accelerate_configuration)
    error_message = "Valid values for var: accelerate_configuration are `Enabled`, `Suspended`."
  }
}

variable "enable_static_website" {
  description = "Whether enable static website"
  type        = bool
  default     = false
}

variable "website_index_suffix" {
  description = "Home suffix of document when create s3 website"
  type        = string
  default     = "index.html"
}

variable "website_error_suffix" {
  description = "Error suffix of document when create s3 website"
  type        = string
  default     = "index.html"
}

################################################################################
# Common Variables
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "master_prefix" {
  description = "To specify a key prefix for aws resource"
  type        = string
  default     = "dso"
  validation {
    condition     = length(var.master_prefix) > 0
    error_message = "Valid values for var: master_prefix cannot be an empty string."
  }
}

variable "aws_region" {
  description = "AWS Region name to deploy resources."
  type        = string
  default     = "ap-southeast-1"
}

########## Server DNS Variables ##########
variable "aws_region" {
  description = "AWS Region the instance is launched in"
  type        = string
  default     = "ap-southeast-1"
}

########## Common Variables ########## 
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

########## Cloudfront Variables ########## 
variable "enable_cloudfront" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether to enable MSK"
}

variable "enable_ipv6" {
  type        = bool
  default     = false
  description = "A boolean flag to determine whether to enable IPv6"
  validation {
    condition     = contains([true, false], var.enable_ipv6)
    error_message = "Valid values for var: enable_ipv6 are `true`, `false`."
  }
}

variable "comment" {
  type        = string
  default     = ""
  description = "Any comments you want to include about the distribution"
}

variable "default_root_object" {
  type        = string
  default     = ""
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
}

variable "logging_config_enabled" {
  type        = bool
  default     = false
  description = "A boolean flag to determine whether to enable logging"
  validation {
    condition     = contains([true, false], var.logging_config_enabled)
    error_message = "Valid values for var: logging_config_enabled are `true`, `false`."
  }
}

variable "include_cookies" {
  type        = bool
  default     = false
  description = "A boolean flag to determine whether to include cookies in logging"
  validation {
    condition     = contains([true, false], var.include_cookies)
    error_message = "Valid values for var: include_cookies are `true`, `false`."
  }
}

variable "logging_config_bucket" {
  type        = string
  default     = ""
  description = "The Amazon S3 bucket to store the access logs in"
}

variable "logging_config_object_prefix" {
  type        = string
  default     = ""
  description = "The Amazon S3 bucket prefix object to store the access logs in"
}

variable "aliases" {
  type        = list(string)
  default     = [""]
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution"
}

variable "web_acl_id" {
  type        = string
  default     = ""
  description = " A unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution"
}

variable "restriction_type" {
  type        = string
  default     = "none"
  description = " The method that you want to use to restrict distribution of your content by country"
  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.restriction_type)
    error_message = "Valid values for var: restriction_type are `none`,`whitelist`, `blacklist`."
  }
}

variable "locations" {
  type        = list(string)
  default     = null
  description = "The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content"
}

variable "price_class" {
  type        = string
  default     = "PriceClass_200"
  description = " The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  validation {
    condition     = contains(["PriceClass_All", "PriceClass_100", "PriceClass_200"], var.price_class)
    error_message = "Valid values for var: price_class are `PriceClass_All`,`PriceClass_100`, `PriceClass_200`."
  }
}

variable "acm_certificate_arn" {
  type        = string
  default     = ""
  description = "The ARN of the AWS Certificate Manager certificate that you wish to use with this distribution"
}

################################################################################
# S3 Variables
################################################################################

variable "s3_bucket_arn" {
  type        = string
  description = "The name of the s3 bucket to export the patch log to"
  default     = "dso"
  validation {
    condition     = length(var.s3_bucket_arn) > 0
    error_message = "Valid values for var: s3_bucket_arn cannot be an empty string."
  }
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the s3 bucket to export the patch log to"
  default     = "dso"
  validation {
    condition     = length(var.s3_bucket_name) > 0
    error_message = "Valid values for var: s3_bucket_name cannot be an empty string."
  }
}

variable "s3_regional_domain_name" {
  type        = string
  description = "The regional domain name of S3 bucket"
  default     = "abc.s3.ap-southeast-1.amazonaws.com"
}

################################################################################
# Route53 Variables
################################################################################
variable "route53_zone_id" {
  type        = string
  description = "route53_zone_id"
  default     = "dso"
  validation {
    condition     = length(var.route53_zone_id) > 0
    error_message = "Valid values for var: route53_zone_id cannot be an empty string."
  }
}

variable "cdn_dns" {
  type        = string
  description = "CDN DNS enpoint"
  default     = "dev"
  validation {
    condition     = length(var.cdn_dns) > 0
    error_message = "Valid values for var: cdn_dns cannot be an empty string."
  }
}

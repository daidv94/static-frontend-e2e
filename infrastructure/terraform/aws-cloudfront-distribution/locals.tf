locals {
  enable_cloudfront = var.enable_cloudfront
  domain_name       = var.s3_regional_domain_name
  # domain_name  = format("%s.%s", var.s3_bucket_name, "s3-website-ap-southeast-1.amazonaws.com")
  s3_origin_id = local.domain_name
}

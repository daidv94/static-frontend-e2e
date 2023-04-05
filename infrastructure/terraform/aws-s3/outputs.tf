output "s3_bucket_name" {
  description = "The S3 bucket name."
  value       = join("", aws_s3_bucket.s3_bucket.*.id)
}

output "s3_bucket_arn" {
  description = "The S3 bucket ARN."
  value       = join("", aws_s3_bucket.s3_bucket.*.arn)
}

output "s3_regional_domain_name" {
  description = "The S3 bucket bucket regional domain name"
  value       = join("", aws_s3_bucket.s3_bucket.*.bucket_regional_domain_name)
}

output "s3_website_domain" {
  description = "website domain"
  value       = join("", aws_s3_bucket_website_configuration.website.*.website_domain)
}

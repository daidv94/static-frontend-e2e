output "cloudfront_distribution_domain_name" {
  description = "The cloudfront distribution domain name"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_distribution_id" {
  description = "The cloudfront distribution id"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = { for k, v in aws_acm_certificate.this : k => v.arn }
}

output "acm_certificate_domain_validation_options" {
  description = "A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if DNS-validation was used."
  value       = [for k, v in aws_acm_certificate.this : v.domain_validation_options]
}

output "acm_certificate_validation_emails" {
  description = "A list of addresses that received a validation E-Mail. Only set if EMAIL-validation was used."
  value       = [for k, v in aws_acm_certificate.this : v.validation_emails]
}

# output "validation_route53_record_fqdns" {
#   description = "List of FQDNs built using the zone domain and name."
#   value       = aws_route53_record.validation.*.fqdn
# }

# # output "distinct_domain_names" {
# #   description = "List of distinct domains names used for the validation."
# #   value       = local.distinct_domain_names
# # }

# output "validation_domains" {
#   description = "List of distinct domain validation options. This is useful if subject alternative names contain wildcards."
#   value       = local.validation_domains
# }

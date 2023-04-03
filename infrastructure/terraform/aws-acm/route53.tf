resource "aws_route53_record" "validation" {
  for_each = local.create_certificate && var.create_route53_records && var.validate_certificate && length(var.domain) > 0 ? var.domain : tomap({})

  zone_id = lookup(each.value, "zone_id", null)
  name    = element(local.validation_domains, index(keys(var.domain), each.key))["resource_record_name"]
  type    = element(local.validation_domains, index(keys(var.domain), each.key))["resource_record_type"]
  ttl     = lookup(each.value, "ttl", 60)

  records = [
    element(local.validation_domains, index(keys(var.domain), each.key))["resource_record_value"]
  ]

  allow_overwrite = var.validation_allow_overwrite_records

  depends_on = [aws_acm_certificate.this]
  provider   = aws.route53
}

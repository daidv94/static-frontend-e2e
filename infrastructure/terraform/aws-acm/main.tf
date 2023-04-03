locals {
  create_certificate = var.create_certificate

  # Get the list of distinct domain_validation_options, with wildcard
  # domain names replaced by the domain name
  validation_domains = local.create_certificate ? distinct(flatten(
    [for acm in aws_acm_certificate.this :
      [for k, v in acm.domain_validation_options : merge(
        tomap(v), { domain_name = replace(v.domain_name, "*.", "") }
    )]]
  )) : []
}

resource "aws_acm_certificate" "this" {
  for_each = local.create_certificate && length(var.domain) > 0 ? var.domain : tomap({})

  domain_name               = lookup(each.value, "domain_name", each.key)
  subject_alternative_names = lookup(each.value, "subject_alternative_names", null)
  validation_method         = lookup(each.value, "validation_method", "DNS")

  options {
    certificate_transparency_logging_preference = lookup(each.value, "certificate_transparency_logging_preference", true) ? "ENABLED" : "DISABLED"
  }

  tags = merge(
    {
      Name = lookup(each.value, "domain_name", each.key)
    },
    lookup(each.value, "tags", {}),
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  for_each = local.create_certificate && var.validate_certificate && var.wait_for_validation && length(var.domain) > 0 ? var.domain : tomap({})

  certificate_arn = aws_acm_certificate.this[each.key].arn

  validation_record_fqdns = flatten([aws_route53_record.validation[each.key].fqdn, var.validation_record_fqdns])
}

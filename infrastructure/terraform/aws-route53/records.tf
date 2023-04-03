locals {
  records = try(jsondecode(var.records), var.records)

  recordsets = flatten([
    for rs in local.records : {
      key     = join(" ", compact(["${rs.name} ${rs.type}", lookup(rs, "set_identifier", ""), try(rs.zone_id, rs.zone_name)]))
      records = rs
  }])
}

resource "aws_route53_record" "record" {
  for_each = { for k, v in local.recordsets : v.key => v.records if var.create_record }

  zone_id                          = try(each.value.zone_id, aws_route53_zone.zone[each.value.zone_name].zone_id)
  name                             = each.value.name
  type                             = each.value.type
  ttl                              = lookup(each.value, "ttl", null)
  records                          = each.value.type == "NS" && try(each.value.zone_name, null) != null ? aws_route53_zone.zone[each.value.zone_name].name_servers : try(each.value.records, null)
  set_identifier                   = lookup(each.value, "set_identifier", null)
  health_check_id                  = lookup(each.value, "health_check_id", null)
  multivalue_answer_routing_policy = lookup(each.value, "multivalue_answer_routing_policy", null)
  allow_overwrite                  = lookup(each.value, "allow_overwrite", false)

  dynamic "alias" {
    for_each = length(keys(lookup(each.value, "alias", {}))) == 0 ? [] : [true]

    content {
      name                   = each.value.alias.name
      zone_id                = try(each.value.alias.zone_id, aws_route53_zone.zone[each.value.zone_name].zone_id)
      evaluate_target_health = lookup(each.value.alias, "evaluate_target_health", false)
    }
  }

  dynamic "failover_routing_policy" {
    for_each = length(keys(lookup(each.value, "failover_routing_policy", {}))) == 0 ? [] : [true]

    content {
      type = each.value.failover_routing_policy.type
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = length(keys(lookup(each.value, "weighted_routing_policy", {}))) == 0 ? [] : [true]

    content {
      weight = each.value.weighted_routing_policy.weight
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = length(keys(lookup(each.value, "geolocation_routing_policy", {}))) == 0 ? [] : [true]

    content {
      continent   = lookup(each.value.geolocation_routing_policy, "continent", null)
      country     = lookup(each.value.geolocation_routing_policy, "country", null)
      subdivision = lookup(each.value.geolocation_routing_policy, "subdivision", null)
    }
  }
}

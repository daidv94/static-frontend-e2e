output "route53_zone_id" {
  description = "Zone ID of Route53 zone"
  value       = { for k, v in aws_route53_zone.zone : k => { zone_id = v.zone_id, name = v.name } }
}

output "route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = { for k, v in aws_route53_zone.zone : k => v.name_servers }
}

output "route53_record_name" {
  description = "The name of the record"
  value       = { for k, v in aws_route53_record.record : k => v.name }
}

output "route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = { for k, v in aws_route53_record.record : k => v.fqdn }
}

terraform {
  source = "../../../../terraform/aws-cloudfront-distribution"
  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "run-all apply",
      "destroy",
      "run-all destroy",
      "plan",
      "run-all plan",
      "output",
      "run-all output",
    ]
  }
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
  cdn_dns     = "ecommerce.${local.common_vars.inputs.dns_name}"
}

# Include all settings from the root terraform.tfvars file
include {
  path = find_in_parent_folders()
}

dependency "acm" {
  config_path = "../../../hli/acm-cdn"
  mock_outputs = {
    acm_certificate_arn = {
      "example.com" = "arn:aws:acm:us-east-1:742068818257:certificate/2c9f780b-f8f6-4c47-8442-12891898391as"
    }
  }
}


dependency "s3" {
  config_path = "../../s3/ecommerce"
  mock_outputs = {
    s3_bucket_arn = "arn:aws:s3:::sample"
  }
}


dependency "route53" {
  config_path = "../../../hli/route53/hostzones"
  mock_outputs = {
    route53_zone_id = {
      "onepiece.daidv.link" = {
        "name"    = "onepiece.daidv.link"
        "zone_id" = "Z04209871JIEGLLPJ6DGW"
      }
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------
inputs = merge(
  local.common_vars.inputs,
  {
    aliases                 = ["${local.cdn_dns}"]
    acm_certificate_arn     = dependency.acm.outputs.acm_certificate_arn[local.common_vars.inputs.dns_name]
    s3_bucket_name          = dependency.s3.outputs.s3_bucket_name
    s3_bucket_arn           = dependency.s3.outputs.s3_bucket_arn
    s3_regional_domain_name = dependency.s3.outputs.s3_regional_domain_name
    enable_ipv6             = true
    route53_zone_id         = dependency.route53.outputs.route53_zone_id[local.common_vars.inputs.dns_name].zone_id
    cdn_dns                 = local.cdn_dns
    default_root_object     = "index.html"
  }
)

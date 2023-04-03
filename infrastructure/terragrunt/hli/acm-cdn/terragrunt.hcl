terraform {
  source = "../../../terraform/aws-acm"
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
}

# Include all settings from the root terraform.tfvars file
include {
  path = find_in_parent_folders()
}

dependency "dns" {
  config_path = "../route53/hostzones"
  mock_outputs = {
    route53_zone_id = {
      "example.com" = {
        "name"    = "example.com"
        "zone_id" = "Z12345678B8AO97GKUA9F"
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
    aws_region = "us-east-1" # CDN require this region
    domain = {
      "${local.common_vars.inputs.dns_name}" = {
        zone_id = dependency.dns.outputs.route53_zone_id[local.common_vars.inputs.dns_name].zone_id
        subject_alternative_names = [
          local.common_vars.inputs.dns_name,
          "*.${local.common_vars.inputs.dns_name}"
        ]
      }
    }
    wait_for_validation = true
  }
)

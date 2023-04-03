terraform {
  source = "../../../../terraform/aws-route53"
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

dependency "route53_hostzones" {
  config_path = "../hostzones"
  mock_outputs = {
    route53_record_fqdn = {}
    route53_record_name = {}
    route53_zone_id = {
      "onepiece.sondinh.link" = {
        "name"    = "onepiece.sondinh.link"
        "zone_id" = "Z084974113LC55DY73WS4"
      }
    }
    route53_zone_name_servers = {
      "onepiece.sondinh.link" = tolist([
        "ns-1312.awsdns-36.org",
        "ns-168.awsdns-21.com",
        "ns-1813.awsdns-34.co.uk",
        "ns-886.awsdns-46.net",
      ])
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
    create_zone = false
    records = [
      # NS records
      ## onepiece
      {
        name    = "onepiece"
        zone_id = "Z08629842WQ9AMLG43R1D"
        records = dependency.route53_hostzones.outputs.route53_zone_name_servers["onepiece.sondinh.link"]
        type    = "NS"
        ttl     = 60
      }
    ]
  }
)

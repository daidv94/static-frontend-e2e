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

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------
inputs = merge(
  local.common_vars.inputs,
  {
    create_zone = true
    zones = {
      "onepiece.sondinh.link" = {
        comment       = "hostzone onepiece.sondinh.link, for poc demo"
        force_destroy = true
        tags = {
          Name = "onepiece.sondinh.link"
        }
      }
    }
  }
)

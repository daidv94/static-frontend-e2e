terraform {
  source = "../../../../terraform/aws-s3"
  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "run-all apply",
      "destroy",
      "run-all destroy",
      "import",
      "plan",
      "run-all plan",
      "push",
      "refresh",
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
    s3_bucket_name        = "kaban-task-management"
    s3_force_destroy      = true
    enable_static_website = true
    s3_public_access_block = {
      block_public_acls       = false
      block_public_policy     = true
      restrict_public_buckets = false
      ignore_public_acls      = true
    }
  }
)

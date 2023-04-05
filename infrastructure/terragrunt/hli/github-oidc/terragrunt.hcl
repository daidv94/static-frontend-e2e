terraform {
  source = "../../../terraform/aws-oidc-github"
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
    enabled                 = true
    attach_admin_policy     = true
    create_oidc_provider    = true
    attach_read_only_policy = false
    iam_role_name           = "github-oidc"
    github_repositories = [
      "sonnydinhgc/OnePiece:ref:refs/heads/main"
    ]
  }
)

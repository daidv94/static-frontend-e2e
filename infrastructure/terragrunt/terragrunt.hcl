# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that supports locking and enforces best
# practices: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
locals {
  # Automatically load input variables
  # account_id          = get_aws_account_id()
  common_vars         = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
  s3_bucket_name      = "${local.common_vars.inputs.master_prefix}-terraform-states-${get_aws_account_id()}-${local.common_vars.inputs.aws_region}"
  dynamodb_table_name = "${local.common_vars.inputs.master_prefix}-terraform-states-lock-${get_aws_account_id()}-${local.common_vars.inputs.aws_region}"
}

remote_state {
  backend = "s3"
  #disable_dependency_optimization = true
  config = {
    encrypt        = true
    bucket         = local.s3_bucket_name
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.common_vars.inputs.aws_region
    dynamodb_table = local.dynamodb_table_name

    s3_bucket_tags = merge(
      local.common_vars.inputs.tags,
      {
        Name = "Terraform state storage"
      }
    )

    dynamodb_table_tags = merge(
      local.common_vars.inputs.tags,
      {
        Name = "Terraform lock table"
      }
    )
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Configure root level variables that all resources can inherit
terraform {
  extra_arguments "bucket" {
    commands = get_terraform_commands_that_need_vars()
    optional_var_files = [
      "${get_terragrunt_dir()}/${find_in_parent_folders("account.tfvars", "ignore")}"
    ]
  }
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=20m"]
  }
}

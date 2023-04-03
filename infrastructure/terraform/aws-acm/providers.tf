# locals {
#   route53_assume_role = var.route53_assume_role == null || var.route53_assume_role == "" ? var.assume_role : var.route53_assume_role
# }

provider "aws" {
  region = var.aws_region
}

# provider "aws" {
#   region = var.aws_region
#   alias  = "route53"

#   assume_role {
#     role_arn = local.route53_assume_role
#   }
# }

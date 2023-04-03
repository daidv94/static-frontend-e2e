<!-- BEGIN\_TF\_DOCS -->
# AWS S3 Module

Terraform module which creates S3 bucket on AWS with all (or almost all) features provided by Terraform AWS provider.

## Usage

```hcl
module "aft-s3-bucket" {
  source = "git@github.com:examplae/aws-s3.git"
  master_prefix  = "dev"
  aws_region     = "ap-southeast-1"
  assume_role    = "arn:aws:iam::111122223333:role/AWSAFTExecution"
  s3_bucket_name = "example"
  s3_lifecycle_rule = [
  {
    id      = "log-delivery"
    enabled = true
    filter = {
      prefix = "*"
    }
    transition = [
      {
        days          = 30
        storage_class = "ONEZONE_IA"
        }, {
        days          = 60
        storage_class = "GLACIER"
      }
    ]
    expiration = {
      days                         = 90
      expired_object_delete_marker = true
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_accelerate_configuration.accelerate_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_acl.bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.cors_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.bucket_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.public_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.server_side_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.deny_insecure_transport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerate_configuration"></a> [accelerate\_configuration](#input\_accelerate\_configuration) | Whether S3 bucket should have an Object Lock configuration enabled. | `string` | `"Enabled"` | no |
| <a name="input_assume_role"></a> [assume\_role](#input\_assume\_role) | AssumeRole to manage the resources within account that owns | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region name to deploy resources. | `string` | `"ap-southeast-1"` | no |
| <a name="input_create_s3"></a> [create\_s3](#input\_create\_s3) | A boolean flag to determine whether to create S3 bucket | `bool` | `true` | no |
| <a name="input_master_prefix"></a> [master\_prefix](#input\_master\_prefix) | To specify a key prefix for aws resource | `string` | `"dso"` | no |
| <a name="input_s3_acl"></a> [s3\_acl](#input\_s3\_acl) | ACL to apply to the S3 bucket | `string` | `"log-delivery-write"` | no |
| <a name="input_s3_bucket_key_enabled"></a> [s3\_bucket\_key\_enabled](#input\_s3\_bucket\_key\_enabled) | Whether to use bucket key enabled to save cost | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 bucket | `string` | `null` | no |
| <a name="input_s3_bucket_override_name"></a> [s3\_bucket\_override\_name](#input\_s3\_bucket\_override\_name) | The override name of the S3 bucket | `string` | `null` | no |
| <a name="input_s3_cors_rule"></a> [s3\_cors\_rule](#input\_s3\_cors\_rule) | List of maps containing rules for Cross-Origin Resource Sharing. | `any` | `[]` | no |
| <a name="input_s3_expected_bucket_owner"></a> [s3\_expected\_bucket\_owner](#input\_s3\_expected\_bucket\_owner) | The account ID of the expected bucket owner | `string` | `null` | no |
| <a name="input_s3_force_destroy"></a> [s3\_force\_destroy](#input\_s3\_force\_destroy) | A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. | `bool` | `false` | no |
| <a name="input_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#input\_s3\_kms\_key\_arn) | The ARN of the KMS CMK to use for encryption | `string` | `null` | no |
| <a name="input_s3_lifecycle_rule"></a> [s3\_lifecycle\_rule](#input\_s3\_lifecycle\_rule) | List of maps containing configuration of object lifecycle management. | `any` | `[]` | no |
| <a name="input_s3_object_lock_enabled"></a> [s3\_object\_lock\_enabled](#input\_s3\_object\_lock\_enabled) | Whether S3 bucket should have an Object Lock configuration enabled. | `bool` | `false` | no |
| <a name="input_s3_policy"></a> [s3\_policy](#input\_s3\_policy) | A valid bucket policy JSON document | `string` | `null` | no |
| <a name="input_s3_public_access_block"></a> [s3\_public\_access\_block](#input\_s3\_public\_access\_block) | Manages S3 account-level Public Access Block configuration. For more information about these settings, see the AWS S3 Block Public Access documentation. | `map(string)` | <pre>{<br>  "block_public_acls": true,<br>  "block_public_policy": true,<br>  "ignore_public_acls": true,<br>  "restrict_public_buckets": true<br>}</pre> | no |
| <a name="input_s3_server_access_logging"></a> [s3\_server\_access\_logging](#input\_s3\_server\_access\_logging) | Map containing access bucket logging configuration. | `map(string)` | `{}` | no |
| <a name="input_s3_sse_algorithm"></a> [s3\_sse\_algorithm](#input\_s3\_sse\_algorithm) | The server-side encryption algorithm to use | `string` | `"AES256"` | no |
| <a name="input_s3_tags"></a> [s3\_tags](#input\_s3\_tags) | Additional tags for S3 bucket | `map(string)` | `{}` | no |
| <a name="input_s3_versioning"></a> [s3\_versioning](#input\_s3\_versioning) | Map containing versioning configuration. | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The S3 bucket ARN. |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The S3 bucket name. |

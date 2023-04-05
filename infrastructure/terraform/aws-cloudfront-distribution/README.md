# Cloudfront distribution Terraform module

Terraform module which deploy Cloudfront distribution.

## Usage
```hcl
module "cloud-front" {
route53_assume_role = local.common_vars.inputs.operations_account_assume_role
aliases             = ["${local.cdn_dns}"]
acm_certificate_arn = dependency.acm.outputs.acm_certificate_arn[local.common_vars.inputs.domain_cloud_dev]
s3_bucket_name      = dependency.s3.outputs.s3_bucket_name
s3_bucket_arn       = dependency.s3.outputs.s3_bucket_arn
enable_ipv6         = true
route53_zone_id     = local.common_vars.inputs.domain_cloud_dev_zone_id
cdn_dns             = local.cdn_dns
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22 |
| <a name="provider_aws.route53"></a> [aws.route53](#provider\_aws.route53) | >= 4.22 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.s3_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.oai](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_route53_record.cdn_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket_policy.s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | The ARN of the AWS Certificate Manager certificate that you wish to use with this distribution | `string` | `""` | no |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Extra CNAMEs (alternate domain names), if any, for this distribution | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_assume_role"></a> [assume\_role](#input\_assume\_role) | AssumeRole to manage the resources within account that owns | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region the instance is launched in | `string` | `"ap-southeast-1"` | no |
| <a name="input_cdn_dns"></a> [cdn\_dns](#input\_cdn\_dns) | CDN DNS enpoint | `string` | `"dso"` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Any comments you want to include about the distribution | `string` | `""` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. | `string` | `""` | no |
| <a name="input_enable_cloudfront"></a> [enable\_cloudfront](#input\_enable\_cloudfront) | A boolean flag to determine whether to enable MSK | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | A boolean flag to determine whether to enable IPv6 | `bool` | `false` | no |
| <a name="input_include_cookies"></a> [include\_cookies](#input\_include\_cookies) | A boolean flag to determine whether to include cookies in logging | `bool` | `false` | no |
| <a name="input_locations"></a> [locations](#input\_locations) | The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content | `list(string)` | `null` | no |
| <a name="input_logging_config_bucket"></a> [logging\_config\_bucket](#input\_logging\_config\_bucket) | The Amazon S3 bucket to store the access logs in | `string` | `""` | no |
| <a name="input_logging_config_enabled"></a> [logging\_config\_enabled](#input\_logging\_config\_enabled) | A boolean flag to determine whether to enable logging | `bool` | `false` | no |
| <a name="input_logging_config_object_prefix"></a> [logging\_config\_object\_prefix](#input\_logging\_config\_object\_prefix) | The Amazon S3 bucket prefix object to store the access logs in | `string` | `""` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | The price class for this distribution. One of PriceClass\_All, PriceClass\_200, PriceClass\_100 | `string` | `"PriceClass_200"` | no |
| <a name="input_restriction_type"></a> [restriction\_type](#input\_restriction\_type) | The method that you want to use to restrict distribution of your content by country | `string` | `"none"` | no |
| <a name="input_route53_assume_role"></a> [route53\_assume\_role](#input\_route53\_assume\_role) | AssumeRole to manage the resources within account containing secret manager. | `string` | `null` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | route53\_zone\_id | `string` | `"dso"` | no |
| <a name="input_s3_bucket_arn"></a> [s3\_bucket\_arn](#input\_s3\_bucket\_arn) | The name of the s3 bucket to export the patch log to | `string` | `"dso"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the s3 bucket to export the patch log to | `string` | `"dso"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | A unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The cloudfront distribution domain name |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The cloudfront distribution id |

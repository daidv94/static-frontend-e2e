# AWS Certificate Manager (ACM) Terraform module

Terraform module which creates AWS ACM.

## Usage

### Route53 DNS validation  on the AWS account created ACM
```hcl
module "acm" {
  source  = "./"
  master_prefix       = "dev"
  aws_region          = "ap-southeast-1"
  assume_role         = "arn:aws:iam::111122223333:role/AWSAFTExecution"
  wait_for_validation = true
  domain = {
    "dev.com.vn" = {
      zone_id = "1234567"
      subject_alternative_names = [
        "dev.com.vn",
        "*.dev.com.vn",
      ]
    }
  }
}
```
### Route53 DNS validation on the another AWS account
```hcl
module "acm" {
  source  = "./"
  master_prefix       = "dev"
  aws_region          = "ap-southeast-1"
  assume_role         = "arn:aws:iam::111122223333:role/AWSAFTExecution"
  route53_assume_role = "arn:aws:iam::444455556666:role/AWSAFTExecution"
  wait_for_validation = true
  domain = {
    "dev.com.vn" = {
      zone_id = "1234567"
      subject_alternative_names = [
        "dev.com.vn",
        "*.dev.com.vn",
      ]
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
| <a name="provider_aws.route53"></a> [aws.route53](#provider\_aws.route53) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role"></a> [assume\_role](#input\_assume\_role) | AssumeRole to manage the resources within account that owns | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region name to deploy resources. | `string` | `"ap-southeast-1"` | no |
| <a name="input_create_certificate"></a> [create\_certificate](#input\_create\_certificate) | Whether to create ACM certificate | `bool` | `true` | no |
| <a name="input_create_route53_records"></a> [create\_route53\_records](#input\_create\_route53\_records) | When validation is set to DNS, define whether to create the DNS records internally via Route53 or externally using any DNS provider | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | List domain name for which the certificate should be issued. Map should contain.<br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate<br>{<br>"uat.com.vn" = {<br>  domain\_name   = "uat.com.vn"<br>  zone\_id       = "1234567"<br>  validation\_method = "DNS"<br>  certificate\_transparency\_logging\_preference = true<br>  subject\_alternative\_names = [<br>    "uat.com.vn",<br>    "*.uat.com.vn",<br>  ]<br>  ttl = 60<br>  tags = {}<br>} | `any` | `null` | no |
| <a name="input_master_prefix"></a> [master\_prefix](#input\_master\_prefix) | To specify a key prefix for aws resource | `string` | `"dso"` | no |
| <a name="input_route53_assume_role"></a> [route53\_assume\_role](#input\_route53\_assume\_role) | AssumeRole to manage the resources within account containing route53. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_validate_certificate"></a> [validate\_certificate](#input\_validate\_certificate) | Whether to validate certificate by creating Route53 record | `bool` | `true` | no |
| <a name="input_validation_allow_overwrite_records"></a> [validation\_allow\_overwrite\_records](#input\_validation\_allow\_overwrite\_records) | Whether to allow overwrite of Route53 records | `bool` | `true` | no |
| <a name="input_validation_record_fqdns"></a> [validation\_record\_fqdns](#input\_validation\_record\_fqdns) | When validation is set to DNS and the DNS validation records are set externally, provide the fqdns for the validation | `list(string)` | `[]` | no |
| <a name="input_wait_for_validation"></a> [wait\_for\_validation](#input\_wait\_for\_validation) | Whether to wait for the validation to complete | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | The ARN of the certificate |
| <a name="output_acm_certificate_domain_validation_options"></a> [acm\_certificate\_domain\_validation\_options](#output\_acm\_certificate\_domain\_validation\_options) | A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if DNS-validation was used. |
| <a name="output_acm_certificate_validation_emails"></a> [acm\_certificate\_validation\_emails](#output\_acm\_certificate\_validation\_emails) | A list of addresses that received a validation E-Mail. Only set if EMAIL-validation was used. |

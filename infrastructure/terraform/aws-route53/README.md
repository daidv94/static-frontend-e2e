# Route53 module

Terraform module which creates Route53 resources.
- Manage Route53 zones
- Manage Route53 records

## Usage

```hcl
module "zone" {
  source             = "git@github.com:examplae/aws-route53.git"
  aws_region         = "ap-southeast-1"
  assume_role        = "arn:aws:iam::111122223333:role/AWSAFTExecution"
  zones = {
    "app.terraform-aws-modules-example.com" = {
      comment = "app.terraform-aws-modules-example.com"
    }

    "private-vpc.terraform-aws-modules-example.com" = {
      # in case than private and public zones with the same domain name
      domain_name = "terraform-aws-modules-example.com"
      comment     = "private-vpc.terraform-aws-modules-example.com"
      vpc = [
        {
          vpc_id = ""vpc-00aabcdf1d1d65a25"
        }
      ]
    }
  }

  records = [
    {
      name = "example"
      zone_id = "Z0012345D0ABCDFLR7OR"
      type = "A"
      ttl  = 3600
      records = [
        "10.10.10.10",
      ]
    },
    {
      name = "alb"
      zone_name = "app.terraform-aws-modules-example.com"
      type = "A"
      alias = {
        name    = "example-123456789012.elb.ap-southeast-1.amazonaws.com"
        zone_id = "ZKVM4W9LS7TM"
      }
    }
  ]
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
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role"></a> [assume\_role](#input\_assume\_role) | AssumeRole to manage the resources within account that owns | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region name to deploy resources. | `string` | `"ap-southeast-1"` | no |
| <a name="input_create_record"></a> [create\_record](#input\_create\_record) | A boolean flag to determine whether to create DNS records in Route53 | `bool` | `true` | no |
| <a name="input_create_zone"></a> [create\_zone](#input\_create\_zone) | A boolean flag to determine whether to create Host Zone in Route53 | `bool` | `true` | no |
| <a name="input_records"></a> [records](#input\_records) | List of maps of DNS records | `any` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Map of Route53 zone parameters | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route53_record_fqdn"></a> [route53\_record\_fqdn](#output\_route53\_record\_fqdn) | FQDN built using the zone domain and name |
| <a name="output_route53_record_name"></a> [route53\_record\_name](#output\_route53\_record\_name) | The name of the record |
| <a name="output_route53_zone_id"></a> [route53\_zone\_id](#output\_route53\_zone\_id) | Zone ID of Route53 zone |
| <a name="output_route53_zone_name_servers"></a> [route53\_zone\_name\_servers](#output\_route53\_zone\_name\_servers) | Name servers of Route53 zone |

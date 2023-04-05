# Monorepos include IAC and frontend services

This repo contains source code to build static frontend services into AWS Cloudfront + S3.</br>
Enhance gitops principle, everything must be configured by source code so we can bring it into other environment fastest as we can.

## Infrastructure

- [Terraform](./infrastructure/terraform/)
- [Terragrunt](./infrastructure/terragrunt/)

## Services

- [Ecommerce](./services/ecommerce/)
- [Kaban task management](./services/kaban-task-management/)

## Get started

Follow the below guide to playaround

### Prerequisite

Make sure you have the following cli tools

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

### Infrastructure

Terragrunt is used to wrap terraform module and pass the configuration variables into it to execute the module
For example create the route53 hostzone

Go to the [hostzones](./infrastructure/terragrunt/hli/route53/hostzones/) directory.

Run

```bash
terragrunt plan
```

If everything ok, run apply to create resource

```bash
terrgrunt apply
```

Similiar to other resources

### Workflows

`Dependency install` -> `caching dependencies` -> `Build` -> `Deploy to CDN` -> `Invalidate cache on CDN`

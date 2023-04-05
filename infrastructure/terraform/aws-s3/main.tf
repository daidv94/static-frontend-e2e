locals {
  s3_bucket_name  = coalesce(var.s3_bucket_override_name, format("%s-%s-%s-%s", var.master_prefix, var.s3_bucket_name, data.aws_caller_identity.current.account_id, data.aws_region.current.name))
  create_s3       = var.create_s3
  s3_policy       = var.s3_policy != null ? var.s3_policy : data.aws_iam_policy_document.deny_insecure_transport[0].json
  lifecycle_rules = try(jsondecode(var.s3_lifecycle_rule), var.s3_lifecycle_rule)
  cors_rules      = try(jsondecode(var.s3_cors_rule), var.s3_cors_rule)
}
resource "aws_s3_bucket" "s3_bucket" {
  count               = local.create_s3 ? 1 : 0
  bucket              = local.s3_bucket_name
  object_lock_enabled = var.s3_object_lock_enabled
  force_destroy       = var.s3_force_destroy

  tags = merge(
    var.tags,
    var.s3_tags
  )

  lifecycle {
    ignore_changes = [
      grant,
      cors_rule,
      lifecycle_rule,
      logging,
      object_lock_configuration,
      replication_configuration,
      server_side_encryption_configuration,
      versioning,
      website
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  count                   = local.create_s3 ? 1 : 0
  bucket                  = aws_s3_bucket.s3_bucket[0].id
  block_public_acls       = lookup(var.s3_public_access_block, "block_public_acls", true)
  block_public_policy     = lookup(var.s3_public_access_block, "block_public_policy", true)
  restrict_public_buckets = lookup(var.s3_public_access_block, "restrict_public_buckets", true)
  ignore_public_acls      = lookup(var.s3_public_access_block, "ignore_public_acls", true)
  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}

resource "aws_s3_bucket_logging" "logging" {
  count         = local.create_s3 && length(keys(var.s3_server_access_logging)) > 0 ? 1 : 0
  bucket        = aws_s3_bucket.s3_bucket[0].id
  target_bucket = var.s3_server_access_logging["target_bucket"]
  target_prefix = try(var.s3_server_access_logging["target_prefix"], null)
}

resource "aws_s3_bucket_versioning" "versioning" {
  count                 = local.create_s3 && length(keys(var.s3_versioning)) > 0 ? 1 : 0
  bucket                = aws_s3_bucket.s3_bucket[0].id
  expected_bucket_owner = var.s3_expected_bucket_owner
  mfa                   = try(var.s3_versioning["mfa"], null)
  versioning_configuration {
    status     = try(var.s3_versioning["enabled"] ? "Enabled" : "Suspended", tobool(var.s3_versioning["status"]) ? "Enabled" : "Suspended", title(lower(var.s3_versioning["status"])))
    mfa_delete = try(tobool(var.s3_versioning["mfa_delete"]) ? "Enabled" : "Disabled", title(lower(var.s3_versioning["mfa_delete"])), null)
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "server_side_encryption" {
  count                 = local.create_s3 ? 1 : 0
  bucket                = aws_s3_bucket.s3_bucket[0].id
  expected_bucket_owner = var.s3_expected_bucket_owner

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_kms_key_arn
      sse_algorithm     = var.s3_sse_algorithm
    }
    bucket_key_enabled = var.s3_bucket_key_enabled
  }
}

resource "aws_s3_bucket_cors_configuration" "cors_configuration" {
  count = local.create_s3 && length(local.cors_rules) > 0 ? 1 : 0

  bucket                = aws_s3_bucket.s3_bucket[0].id
  expected_bucket_owner = var.s3_expected_bucket_owner

  dynamic "cors_rule" {
    for_each = local.cors_rules

    content {
      id              = try(cors_rule.value.id, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  count  = local.create_s3 ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket[0].id
  acl    = var.s3_acl
}

resource "aws_s3_bucket_policy" "policy" {
  count  = local.create_s3 ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket[0].id
  policy = local.s3_policy
}


resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  count                 = local.create_s3 && length(local.lifecycle_rules) > 0 ? 1 : 0
  bucket                = aws_s3_bucket.s3_bucket[0].id
  expected_bucket_owner = var.s3_expected_bucket_owner

  dynamic "rule" {
    for_each = local.lifecycle_rules

    content {
      id     = try(rule.value.id, null)
      status = try(rule.value.enabled ? "Enabled" : "Disabled", tobool(rule.value.status) ? "Enabled" : "Disabled", title(lower(rule.value.status)))

      # Max 1 block - abort_incomplete_multipart_upload
      dynamic "abort_incomplete_multipart_upload" {
        for_each = try([rule.value.abort_incomplete_multipart_upload_days], [])

        content {
          days_after_initiation = try(rule.value.abort_incomplete_multipart_upload_days, null)
        }
      }

      # Max 1 block - expiration
      dynamic "expiration" {
        for_each = try(flatten([rule.value.expiration]), [])

        content {
          date                         = try(expiration.value.date, null)
          days                         = try(expiration.value.days, null)
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
        }
      }

      # Several blocks - transition
      dynamic "transition" {
        for_each = try(flatten([rule.value.transition]), [])

        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }

      # Max 1 block - noncurrent_version_expiration
      dynamic "noncurrent_version_expiration" {
        for_each = try(flatten([rule.value.noncurrent_version_expiration]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_expiration.value.days, noncurrent_version_expiration.value.noncurrent_days, null)
        }
      }

      # Several blocks - noncurrent_version_transition
      dynamic "noncurrent_version_transition" {
        for_each = try(flatten([rule.value.noncurrent_version_transition]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_transition.value.days, noncurrent_version_transition.value.noncurrent_days, null)
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }

      # Max 1 block - filter - without any key arguments or tags
      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []

        content {
          #          prefix = ""
        }
      }

      # Max 1 block - filter - with one key argument or a single tag
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) == 1]

        content {
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)
          prefix                   = try(filter.value.prefix, null)

          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])

            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      # Max 1 block - filter - with more than one key arguments or multiple tags
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) > 1]

        content {
          and {
            object_size_greater_than = try(filter.value.object_size_greater_than, null)
            object_size_less_than    = try(filter.value.object_size_less_than, null)
            prefix                   = try(filter.value.prefix, null)
            tags                     = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }

  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]
}

resource "aws_s3_bucket_accelerate_configuration" "accelerate_configuration" {
  bucket = aws_s3_bucket.s3_bucket[0].id
  status = var.accelerate_configuration
}

resource "aws_s3_bucket_website_configuration" "website" {
  count  = local.create_s3 && var.enable_static_website ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket[0].id

  index_document {
    suffix = var.website_index_suffix
  }

  error_document {
    key = var.website_error_suffix
  }
}

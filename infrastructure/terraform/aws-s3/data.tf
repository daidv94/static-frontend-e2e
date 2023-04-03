data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "deny_insecure_transport" {
  count = local.create_s3 ? 1 : 0

  statement {
    sid    = "denyInsecureTransport"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.s3_bucket[0].arn,
      "${aws_s3_bucket.s3_bucket[0].arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}

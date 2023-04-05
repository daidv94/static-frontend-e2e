resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = var.comment
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = local.domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = local.enable_cloudfront
  is_ipv6_enabled     = var.enable_ipv6
  comment             = var.comment
  default_root_object = var.default_root_object

  dynamic "logging_config" {
    for_each = var.logging_config_enabled ? [1] : []
    content {
      include_cookies = var.include_cookies
      bucket          = var.logging_config_bucket
      prefix          = var.logging_config_object_prefix
    }
  }

  aliases    = var.aliases
  web_acl_id = var.web_acl_id

  # default_cache_behavior {
  #   allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  #   cached_methods   = ["GET", "HEAD"]
  #   target_origin_id = local.s3_origin_id

  #   forwarded_values {
  #     query_string = false

  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   viewer_protocol_policy = "allow-all"
  #   min_ttl                = 0
  #   default_ttl            = 3600
  #   max_ttl                = 86400
  # }


  # Cache behavior with precedence 1
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = var.locations
    }
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }


  tags = merge(
    var.tags,
    {
      Name = local.domain_name
    }
  )
  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = var.s3_bucket_name
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_route53_record" "cdn_record" {
  zone_id = var.route53_zone_id
  name    = var.cdn_dns
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.s3_distribution.domain_name]
  # provider = aws.route53
}

locals {
  s3_origin_id = aws_s3_bucket.main.id
}

resource "aws_cloudfront_origin_access_identity" "main" {
  comment = "${var.prefix}-main"
}

resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.index_document

  aliases    = [var.domain_name]
  web_acl_id = join("", aws_waf_web_acl.main.*.id)

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    max_ttl     = 0
    default_ttl = 0

    dynamic "lambda_function_association" {
      for_each = var.basic_auth_enabled ? [aws_lambda_function.basic_auth.0.qualified_arn] : []

      content {
        event_type   = "viewer-request"
        lambda_arn   = lambda_function_association.value
        include_body = false
      }
    }
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }


}

resource "aws_cloudfront_distribution" "redirect" {
  count = var.redirect_domain_name != "null" ? 1 : 0

  origin {
    domain_name = "${var.redirect_domain_name}.s3-website-eu-west-1.amazonaws.com"
    origin_id   = "S3Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 80
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["SSLv3", "TLSv1"]
    }
  }

  enabled         = true
  is_ipv6_enabled = false

  aliases = [var.redirect_domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    max_ttl     = 0
    default_ttl = 0
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}

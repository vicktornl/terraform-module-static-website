data "template_file" "index" {
  template = templatefile("${path.module}/templates/index.html", {
    domain_name = var.domain_name
  })
}

data "template_file" "error" {
  template = templatefile("${path.module}/templates/error.html", {
    domain_name = var.domain_name
  })
}

resource "aws_s3_bucket" "main" {
  bucket = var.domain_name

  website {
    index_document = var.index_document
    error_document = var.error_document
  }
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

resource "aws_s3_bucket" "redirect" {
  count  = var.redirect_domain_name != "null" ? 1 : 0
  bucket = var.redirect_domain_name

  website {
    redirect_all_requests_to = "https://${var.domain_name}"
  }
}

resource "aws_s3_bucket_public_access_block" "redirect" {
  count  = var.redirect_domain_name != "null" ? 1 : 0
  bucket = aws_s3_bucket.redirect.0.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "redirect" {
  count  = var.redirect_domain_name != "null" ? 1 : 0
  bucket = aws_s3_bucket.redirect.0.id
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.main.id
  key          = "index.html"
  content      = data.template_file.index.rendered
  content_type = "text/html"

  lifecycle {
    ignore_changes = ["source"]
  }
}

resource "aws_s3_bucket_object" "error" {
  bucket       = aws_s3_bucket.main.id
  key          = "error.html"
  content      = data.template_file.error.rendered
  content_type = "text/html"

  lifecycle {
    ignore_changes = ["source"]
  }
}

data "aws_iam_policy_document" "main" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.main.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
    }
  }

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.main.json
}

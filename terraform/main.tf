provider "aws" {
  region = var.aws_region
}

resource "random_id" "bucket_id" {
  byte_length = 2
}

locals {
  bucket_name = "${var.app_name}-${random_id.bucket_id.hex}"
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = var.app_name
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.app_bucket.bucket

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.app_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.app_name}"
}

resource "aws_s3_bucket_policy" "app_bucket_policy" {
  bucket = aws_s3_bucket.app_bucket.id

  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.app_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

resource "aws_s3_object" "app_files" {
  for_each = fileset("../build", "**/*")

  bucket = aws_s3_bucket.app_bucket.bucket
  key    = each.value
  source = "../build/${each.value}"
  etag   = filemd5("../build/${each.value}")

  content_type = each.value == "index.html" ? "text/html" : lookup(
    var.mime_types,
    lower(regex("[^.]*$", each.value)),
    "application/octet-stream"
  )

  # Ensure `content_disposition` is not set
}



resource "aws_cloudfront_distribution" "app_cdn" {
  origin {
    domain_name = aws_s3_bucket.app_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.app_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.app_bucket.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = var.app_name
    Environment = "Dev"
  }
}

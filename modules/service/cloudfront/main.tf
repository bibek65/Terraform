data "aws_s3_bucket" "s3" {
  bucket = var.bucket_name_id
}


resource "aws_s3_bucket_policy" "origin" {
  depends_on = [
    aws_cloudfront_distribution.s3_distribution
  ]
  bucket = data.aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.origin.json
}

data "aws_iam_policy_document" "origin" {
  depends_on = [
    aws_cloudfront_distribution.s3_distribution,
    data.aws_s3_bucket.s3
  ]
  statement {
    sid    = "3"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${data.aws_s3_bucket.s3.id}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.s3_distribution.arn
      ]
    }
  }
}


resource "aws_cloudfront_distribution" "s3_distribution" {

  depends_on = [
    data.aws_s3_bucket.s3,
    aws_cloudfront_origin_access_control.s3_distribution
  ]


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = data.aws_s3_bucket.s3.id


    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin {
    domain_name              = "${data.aws_s3_bucket.s3.id}.s3.amazonaws.com"
    origin_id                = data.aws_s3_bucket.s3.id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_distribution.id

  }


  price_class = "PriceClass_100"

  enabled             = true
  default_root_object = "index.html"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "Bibek Cloud front"
  }
}

resource "aws_cloudfront_origin_access_control" "s3_distribution" {
  name                              = "${var.oac_name}-OAC"
  description                       = "OAC setup for S3_OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

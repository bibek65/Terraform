resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.default.id
  key    = each.value

  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "json" = "application/json",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "svg"  = "image/svg+xml"
  }, element(split(".", basename(each.value)), length(split(".", basename(each.value))) - 1), "binary/octet-stream")

  for_each = fileset("C:/Users/DELL/Desktop/Terraform/dist/", "**/*")

  source = "C:/Users/DELL/Desktop/Terraform/dist/${each.value}"

}

output "bucket_domain_name" {
  value = aws_s3_bucket.default.bucket_domain_name
}

output "s3_bucket_id" {
  value = aws_s3_bucket.default.id
}

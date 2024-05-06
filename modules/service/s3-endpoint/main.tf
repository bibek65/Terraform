resource "aws_s3_bucket" "endpoint_bucket" {
  bucket = "my-allowed-bucket"
  tags = {
    Name = "my-allowed-bucket"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.us-west-2.s3"
  route_table_ids = [var.route_table_id]
  vpc_endpoint_type = "Gateway"

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-allowed-bucket/*",
      "Principal": "*"
    }
  ]
}
POLICY

 tags = {
    Name = "app-vpce-s3"
  }
}





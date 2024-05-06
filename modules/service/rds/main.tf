resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "RDS DB subnet group"
  }
}
resource "aws_db_instance" "primary" {
  allocated_storage    = 10
  db_name              = "primarydb"
  engine               = "postgres"
  engine_version       = "16.1-R2"
  instance_class       = "db.t3.medium"
  username             = "admin"
  password             = "securepassword123"
  skip_final_snapshot  = true
  multi_az             = true
  db_subnet_group_name = aws_db_subnet_group.default.name
}


resource "aws_db_instance" "read_replica" {
  identifier         = "read-replica"
  replicate_source_db = aws_db_instance.primary.id
  instance_class     = "db.t3.micro"
  availability_zone  = "us-east-1b"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.default.name
}

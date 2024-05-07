resource "aws_secretsmanager_secret" "secret" {
  name = "env-secret"
  description = "Secret for environment variables"
  tags = {
    Name = "env-secret"
  }
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
 secret_id = aws_secretsmanager_secret.secret.id
 secret_string = var.db_password
}  


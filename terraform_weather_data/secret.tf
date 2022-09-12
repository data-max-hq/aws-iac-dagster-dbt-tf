resource "aws_secretsmanager_secret" "api-key" {
  name = "API_KEY_S-${random_string.suffix.result}"
}
resource "aws_secretsmanager_secret" "aws-access-key-id" {
  name = "AWS_ACCESS_KEY_ID_S-${random_string.suffix.result}"
}
resource "aws_secretsmanager_secret" "aws-secret-access-key" {
  name = "AWS_SECRET_ACCESS_KEY_S-${random_string.suffix.result}"
}


data "aws_secretsmanager_secret_version" "api-key" {
  secret_id = aws_secretsmanager_secret.api-key.id
}
data "aws_secretsmanager_secret_version" "aws-access-key-id" {
  secret_id = aws_secretsmanager_secret.aws-access-key-id.id
}
data "aws_secretsmanager_secret_version" "aws-secret-access-key" {
  secret_id = aws_secretsmanager_secret.aws-secret-access-key.id
}



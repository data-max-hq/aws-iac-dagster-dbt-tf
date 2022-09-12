resource "aws_ecr_repository" "weather-data-on-dagster" {
  name                 = "weather-data-on-dagster"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
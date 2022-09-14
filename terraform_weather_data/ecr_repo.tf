resource "aws_ecr_repository" "weather-data-on-dagster" {
  name                 = "weather-data-on-dagster"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "weather-data-on-dagster" {
  repository = aws_ecr_repository.weather-data-on-dagster.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

data "aws_ecr_repository" "image" {
  name = aws_ecr_repository.weather-data-on-dagster.name
}
terraform {
  backend "s3" {}
}

resource "aws_ecr_repository" "sandbox" {
  name                 = "sandbox"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "sandbox"
  }
}

resource "aws_ecr_lifecycle_policy" "sandbox" {
  repository = aws_ecr_repository.sandbox.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 3 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
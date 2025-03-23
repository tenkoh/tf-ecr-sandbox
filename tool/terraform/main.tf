terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.92.0"
    }
  }
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

locals {
  image_names = [
    "image1",
    "image2",
  ]
}

resource "null_resource" "build_images" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOF
		set -eu
		aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.aws_account}.dkr.ecr.${var.aws_region}.amazonaws.com
		for image in ${join(" ", local.image_names)}; do
			tag="${aws_ecr_repository.sandbox.repository_url}:$image"
			docker build --target "$image" -t "$tag" ../..
			docker push "$tag"
			# some comment here
			echo "Image $tag pushed"
		done
		EOF
  }
}
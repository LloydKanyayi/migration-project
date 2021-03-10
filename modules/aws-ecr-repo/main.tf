#--------------aws-ecr-repo/main.tf

resource "aws_ecr_repository" "main" {
  name                 = "my-repo"
  image_tag_mutability = "MUTABLE"
}

#----------------setting a lifecycle policy on tagged image

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 10 images",
            "selection": {
                "tagStatus": "any",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
locals {
  rds_master_secret_arn     = aws_db_instance.rds_demo.master_user_secret[0].secret_arn
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_ro_role" {
  name = var.ec2_ro_role_name

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags = {
    Name        =  var.ec2_ro_role_name
  }
}

resource "aws_iam_instance_profile" "ec2_ro_profile" {
  name = var.ec2_ro_role_name
  role = aws_iam_role.ec2_ro_role.name
}

# resource "aws_iam_policy" "s3_backups_ro_policy" {
#   name = "S3-RO"
#   description = "Policy to access S3 bucket from EC2"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "s3:DescribeJob",
#           "s3:Get*",
#           "s3:List*"
#         ]
#         Effect   = "Allow"
#         Resource = ["arn:aws::s3:::${var.backup_bucket_name}/*"]
#       },
#     ]
#   })
#   tags = {
#     Name        = "S3-RO"
#   }
# }

resource "aws_iam_policy" "secrets_manager_access" {
  name        = "SecretsManager_RO_Access"
  description = "Policy to access secrets from EC2"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "GetSecretValue"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:core/dc/ip*",
          "${local.rds_master_secret_arn}"
        ]
      }
    ]
  })
  
  tags = {
    Name        = "SecretsManager_RO_Access"
  }
}

resource "aws_iam_role_policy_attachment" "SSMInstanceCore_2_ec2_ro_role" {
  role       = aws_iam_role.ec2_ro_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_secrets_policy_attachment" {
  role       = aws_iam_role.ec2_ro_role.name
  policy_arn = aws_iam_policy.secrets_manager_access.arn
}

locals {
  user_data = base64encode(templatefile("${path.module}/templates/deploy_app.sh", {
    DB_HOST     = aws_db_instance.rds_demo.address
    DB_PASSWORD = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string).password
    AWS_REGION  = var.aws_region
  }))
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = local.rds_master_secret_arn
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_ro_profile.name
  vpc_security_group_ids      = [local.sg_web_id, local.sg_db_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = local.user_data

  tags = {
    Name = "Web_server"
  }
  depends_on = [aws_db_instance.rds_demo]
}


# Deploy Elasticsearch
module "elasticsearch" {
  source = "git@github.com:DvO-test-org/pex-es-module.git?ref=v0.1.2"

  name_prefix = "my-elasticsearch"
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.private_subnets[0]
  key_name    = var.key_name

  instance_type         = "t3.medium"
  elasticsearch_version = "8.11.0"
  cluster_name          = "my-single-node"
  heap_size             = "2g"

  volume_size      = 20
  data_volume_size = 30

  allowed_cidr_blocks = [var.vpc_cidr]
  assign_public_ip    = false
  ssh_sg_ids          = [aws_security_group.sg_bastion.id]

  encrypt_volume = true
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [local.sg_bastion_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_ssm_parameter" "db_ip" {
  name  = "/dev/db/MYSQL_HOST"
  type  = "String"
  value = aws_db_instance.rds_demo.address
}

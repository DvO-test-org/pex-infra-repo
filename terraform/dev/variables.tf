variable "Environment" {
  type        = string
  default     = "dev"
  description = "Environment name"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "aws_region" {
  type        = string
  default     = "eu-north-1"
  description = "AWS region name"
}

variable "github_account" {
  type        = string
  default     = "saaverdo"
  description = "Github account name"
}

variable "github_repo" {
  type        = string
  default     = "pex-app-repo"
  description = "Github repo name"
}

variable "ec2_ro_role_name" {
  type        = string
  default     = "dev_ro_role"
  description = "S3 and Secrets Read-Only role name for EC2"
}

variable "s3_ro_policy_name" {
  type        = string
  default     = "s3_ro_policy"
  description = "S3 Read-Only policy name"
}
variable "secrets_ro_policy_name" {
  type        = string
  default     = "secrets_ro_policy"
  description = "Secrets Manager Read-Only policy name"
}

variable "backup_bucket_name" {
  type        = string
  default     = "pex-bsv-backup-bucket"
  description = "Bucket for backups name"
}

variable "vpc_name" {
  type        = string
  default     = "pex-vpc"
  description = "VPC name"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC supernet CIDR"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Instance shape"
}

variable "key_name" {
  type        = string
  default     = "web-key"
  description = "Key pair name"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "nginx-packer-linux-hcl-3"
  instance_type = "t3.micro"
  region        = "eu-north-1"
  # source_ami    = "${var.base_ami}"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-*-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  # iam_instance_profile = "s3-ro-test-role"
}

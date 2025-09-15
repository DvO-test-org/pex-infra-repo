terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "pex-bsv-tf-state-bucket"
    use_lockfile = true
    key          = "dev/terraform.tfstate"
    region       = "eu-north-1"
  }
}
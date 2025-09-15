resource "aws_s3_bucket" "backend" {
  bucket = "pex-bsv-tf-state-bucket"
  tags = {
    Name    = "TF state bucket"
    Project = "PEX"
    Task    = "CM-J-3"
  }
}

resource "aws_s3_bucket_versioning" "versioning_backend" {
  bucket = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "state_bucket" {
  value = aws_s3_bucket.backend.bucket
}

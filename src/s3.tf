
resource "aws_s3_bucket" "code_deploy" {
  bucket = var.name_bucket_cd
  force_destroy = true
  tags = {
    Name = "Bucket para armazenar artifacts do dpeloy"
  }

}

resource "aws_s3_bucket_versioning" "versionamento" {
  bucket = aws_s3_bucket.code_deploy.id
  versioning_configuration {
    status = "Enabled"
  }
}


output "bucket_name" {
  value = aws_s3_bucket.code_deploy.bucket
}


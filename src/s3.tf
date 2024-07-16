
resource "aws_s3_bucket" "code_deploy" {
  bucket = "${var.instance_name}-deploy"  # substitua pelo nome único do seu bucket S3

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
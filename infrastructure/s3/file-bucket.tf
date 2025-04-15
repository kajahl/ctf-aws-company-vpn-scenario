resource "aws_s3_bucket" "my_bucket" {
  bucket = "s3-ctf-files-bucket"

  tags = {
    Name        = "CTF Files"
    Environment = "Dev"
  }

  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

output "bucket_id" {
    value = aws_s3_bucket.my_bucket.id
}

output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}
resource "aws_s3_object" "soc_key_file" {
  bucket       = var.bucket_name
  key          = "${var.bucket_file_prefix}/soc-key.pem"
  source       = "infrastructure/keys/soc-key.pem"
  content_type = "application/x-pem-file"

  depends_on = [var.soc_key_dependency]
}

resource "aws_s3_object" "company_soc_files" {
  bucket       = var.bucket_name
  key          = "${var.bucket_file_prefix}/files.zip"
  source       = "${path.module}/files.zip"
  content_type = "application/zip"
}
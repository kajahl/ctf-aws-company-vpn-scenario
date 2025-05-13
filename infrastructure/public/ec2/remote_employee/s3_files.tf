resource "aws_s3_object" "remote_employee_files" {
  bucket       = var.bucket_name
  key          = "${var.bucket_file_prefix}/files.zip"
  source       = "${path.module}/files.zip"
  content_type = "application/zip"
}
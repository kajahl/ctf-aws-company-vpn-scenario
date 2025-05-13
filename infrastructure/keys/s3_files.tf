resource "aws_s3_object" "soc_key" {
  bucket       = var.bucket_name
  key          = "${var.bucket_file_prefix}/soc-key.pem"
  source       = "${path.module}/soc-key.pem"
  content_type = "application/x-pem-file"
}

resource "aws_s3_object" "employee_key" {
  bucket       = var.bucket_name
  key          = "${var.bucket_file_prefix}/employee-key.pem"
  source       = "${path.module}/employee-key.pem"
  content_type = "application/x-pem-file"
}

output "soc_key_s3_id" {
  value       = aws_s3_object.soc_key.id
  description = "The S3 ID of the SOC key"
}

output "employee_key_s3_id" {
  value       = aws_s3_object.employee_key.id
  description = "The S3 ID of the Employee key"
}
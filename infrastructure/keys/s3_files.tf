resource "aws_s3_object" "soc_key" {
  bucket       = var.bucket_name
  key          = "${var.bucket_file_prefix}/soc-key.pem"
  source       = "${path.module}/soc-key.pem"
  content_type = "application/x-pem-file"
  depends_on = [ aws_key_pair.generated_employee_key ]
}

resource "aws_s3_object" "employee_key" {
  bucket       = var.bucket_name
  key          = "${var.bucket_file_prefix}/employee-key.pem"
  source       = "${path.module}/employee-key.pem"
  content_type = "application/x-pem-file"
  depends_on = [ aws_key_pair.generated_employee_key ]
}

resource "aws_s3_object" "noaccess_key" {
  bucket       = var.bucket_name
  key          = "${var.bucket_file_prefix}/noaccess-key.pem"
  source       = "${path.module}/noaccess-key.pem"
  content_type = "application/x-pem-file"
  depends_on = [ aws_key_pair.generated_employee_key ]
}

resource "aws_s3_object" "ctf_key" {
  bucket       = var.bucket_name
  key          = "${var.bucket_file_prefix}/ctf-key.pem"
  source       = "${path.module}/ctf-key.pem"
  content_type = "application/x-pem-file"
  depends_on = [ aws_key_pair.generated_employee_key ]
}

output "soc_key_s3_id" {
  value       = aws_s3_object.soc_key.id
  description = "The S3 ID of the SOC key"
}

output "employee_key_s3_id" {
  value       = aws_s3_object.employee_key.id
  description = "The S3 ID of the Employee key"
}

output "noaccess_key_s3_id" {
  value       = aws_s3_object.noaccess_key.id
  description = "The S3 ID of the No Access key"
}

output "ctf_key_s3_id" {
  value       = aws_s3_object.ctf_key.id
  description = "The S3 ID of the CTF key"
}
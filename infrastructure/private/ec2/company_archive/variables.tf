variable "ami_id" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "company_subnet_id" {}
variable "company_sg_id" {}
variable "ec2_name" {
  default = "Company Archive"
}
variable "user_data" {}

variable "remote_key_name" {}
variable "public_ip" {
  default = false
}

variable "bucket_id" {}
variable "bucket_name" {}
variable "bucket_file_prefix" {
  default = "company-archive"
}

variable "soc_key_dependency" {}

variable "soc_key_s3_id" {
  description = "The S3 ID of the SOC key"
  type        = string
}
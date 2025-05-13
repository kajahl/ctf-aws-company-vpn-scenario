variable "ami_id" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "external_subnet_id" {}
variable "external_sg_id" {}
variable "ec2_name" {
  default = "Remote Employee"
}

variable "remote_key_name" {}
variable "user_data" {}
variable "public_ip" {
  default = false
}

variable "bucket_id" {}
variable "bucket_name" {}
variable "bucket_file_prefix" {
  default = "remote-employee"
}

variable "shared_subnet_id" {
  description = "The ID of the shared subnet"
  type        = string
}

variable "shared_sg_id" {
  description = "The ID of the shared security group"
  type        = string
}

variable "employee_key_s3_id" {
    description = "The S3 ID of the Employee key"
    type        = string
}
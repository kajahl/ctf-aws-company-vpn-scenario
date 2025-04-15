variable "ami_id" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "company_subnet_id" {}
variable "company_sg_id" {}
variable "ec2_name" {
  default = "Company SOC"
}
variable "user_data" {}

variable "company_dev_sg_id" {}
variable "remote_key_name" {}
variable "public_ip" {
  default = false
}

variable bucket_id {}
variable bucket_name {}
variable bucket_file_prefix {
  default = "company-soc"
}

variable soc_key_dependency {}
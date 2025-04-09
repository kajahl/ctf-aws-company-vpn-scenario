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

variable "company_dev_sg_id" {}
variable "remote_key_name" {}
variable "public_ip" {
  default = false
}
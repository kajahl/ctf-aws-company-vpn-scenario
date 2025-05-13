provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

### General ###

module "ami" {
  source = "./infrastructure/ami"
  # outputs -> ami_id
}

module "keys" {
  source = "./infrastructure/keys"

  bucket_file_prefix = "keys"
  bucket_name = module.s3.bucket_name
  # outputs -> remote_key_name
}

module "s3" {
  source = "./infrastructure/s3"

  # outputs -> bucket_id, bucket_name
}

### Shared infrastructure ###

module "shared" {
  source = "./infrastructure/shared"
  # outputs -> shared_subnet_id, shared_sg_id
}

### Public infrastructure ###

module "public_infrastructure" {
  source = "./infrastructure/public"
  # public_vpc: outputs -> external_vpc_id, external_subnet_id
  # public_sg: outputs -> external_sg_id
  # public_gateway: outputs -> None
}

module "public_ec2_employee" {
  source             = "./infrastructure/public/ec2/remote_employee/"
  ami_id             = module.ami.ami_id
  instance_type      = "t2.micro"
  external_subnet_id = module.public_infrastructure.external_subnet_id
  external_sg_id     = module.public_infrastructure.external_sg_id
  remote_key_name    = module.keys.remote_key_name
  user_data          = file("./infrastructure/public/ec2/remote_employee/init.sh")
  ec2_name           = "Remote Employee"
  public_ip          = true
  bucket_id          = module.s3.bucket_id
  bucket_name        = module.s3.bucket_name
  shared_subnet_id   = module.shared.shared_subnet_id
  shared_sg_id       = module.shared.shared_sg_id
  employee_key_s3_id = module.keys.employee_key_s3_id
}

### Private infrastructure ###

module "company_infrastructure" {
  source = "./infrastructure/private/"
  # private_vpc: outputs -> company_vpc_id, company_subnet_id
  # private_sg: outputs -> company_sg_id
  # private_gateway: outputs -> None
}

module "company_ec2_employee" {
  source            = "./infrastructure/private/ec2/company_employee"
  ami_id            = module.ami.ami_id
  instance_type     = "t2.micro"
  company_subnet_id = module.company_infrastructure.company_subnet_id
  company_sg_id     = module.company_infrastructure.company_sg_id
  user_data         = file("./infrastructure/private/ec2/company_employee/init.sh")
  ec2_name          = "Company Employee"
  bucket_id         = module.s3.bucket_id
  bucket_name       = module.s3.bucket_name
  shared_subnet_id  = module.shared.shared_subnet_id
  shared_sg_id      = module.shared.shared_sg_id

  # Dev
  remote_key_name   = module.keys.employee_key_name
  public_ip         = false
}

module "company_ec2_soc" {
  source             = "./infrastructure/private/ec2/company_soc"
  ami_id             = module.ami.ami_id
  instance_type      = "t2.micro"
  company_subnet_id  = module.company_infrastructure.company_subnet_id
  company_sg_id      = module.company_infrastructure.company_sg_id
  user_data          = file("./infrastructure/private/ec2/company_soc/init.sh")
  ec2_name           = "Company SOC"
  remote_key_name    = module.keys.soc_key_name
  bucket_id          = module.s3.bucket_id
  bucket_name        = module.s3.bucket_name
  soc_key_dependency = module.keys.soc_private_key

  # Dev
  public_ip         = false
}

module "company_ec2_archive" {
  source             = "./infrastructure/private/ec2/company_archive"
  ami_id             = module.ami.ami_id
  instance_type      = "t2.micro"
  company_subnet_id  = module.company_infrastructure.company_subnet_id
  company_sg_id      = module.company_infrastructure.company_sg_id
  ec2_name           = "Company Archive"
  user_data          = file("./infrastructure/private/ec2/company_archive/init.sh")
  bucket_id          = module.s3.bucket_id
  bucket_name        = module.s3.bucket_name
  soc_key_dependency = module.keys.soc_private_key
  soc_key_s3_id = module.keys.soc_key_s3_id

  # Dev
  remote_key_name   = module.keys.noaccess_key_name
  public_ip         = false
}

output "external_pc_public_ip" {
  value       = module.public_ec2_employee.external_pc_public_ip
  description = "Public IP of the Remote Employee EC2 instance"
}
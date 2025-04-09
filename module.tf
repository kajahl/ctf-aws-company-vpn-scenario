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
  # outputs -> remote_key_name
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
}

### Private infrastructure ###

module "company_infrastructure" {
  source = "./infrastructure/private/"
  # private_vpc: outputs -> company_vpc_id, company_subnet_id
  # private_sg: outputs -> company_sg_id
  # private_dev_sg: outputs -> company_dev_sg_id
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

  remote_key_name   = module.keys.remote_key_name
  company_dev_sg_id = module.company_infrastructure.company_dev_sg_id
  public_ip         = true
}

module "company_ec2_soc" {
  source            = "./infrastructure/private/ec2/company_soc"
  ami_id            = module.ami.ami_id
  instance_type     = "t2.micro"
  company_subnet_id = module.company_infrastructure.company_subnet_id
  company_sg_id     = module.company_infrastructure.company_sg_id
  user_data         = file("./infrastructure/private/ec2/company_soc/init.sh")
  ec2_name          = "Company SOC"
  public_ip         = true

  remote_key_name   = module.keys.remote_key_name
  company_dev_sg_id = module.company_infrastructure.company_dev_sg_id
}

module "company_ec2_archive" {
  source            = "./infrastructure/private/ec2/company_archive"
  ami_id            = module.ami.ami_id
  instance_type     = "t2.micro"
  company_subnet_id = module.company_infrastructure.company_subnet_id
  company_sg_id     = module.company_infrastructure.company_sg_id
  ec2_name          = "Company Archive"
  user_data         = file("./infrastructure/private/ec2/company_archive/init.sh")

  remote_key_name   = module.keys.remote_key_name
  company_dev_sg_id = module.company_infrastructure.company_dev_sg_id
  public_ip         = true
}
resource_name_prefix = "workshop-rttdoa"
project_name         = "real-time-threat-detection-on-aws"
environment          = "demo"
region               = "eu-west-1"

#######################################
# VPC
#######################################

main_vpc_cfg = {
  azs               = ["eu-west-1a", "eu-west-1b"]
  cidr              = "10.0.0.0/16"
  private_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  protected_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnets    = ["10.0.201.0/24", "10.0.202.0/24"]
}

security_vpc_cfg = {
  azs                = ["eu-west-1a", "eu-west-1b"]
  cidr               = "10.10.0.0/16"
  private_subnets    = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets     = ["10.10.201.0/24", "10.10.202.0/24"]
  enable_nat_gateway = true
}

monitored_instances = 2
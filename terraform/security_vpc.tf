module "security_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name = local.security_vpc_name
  cidr = var.security_vpc_cfg.cidr

  azs             = var.security_vpc_cfg.azs
  private_subnets = var.security_vpc_cfg.private_subnets
  public_subnets  = var.security_vpc_cfg.public_subnets

  enable_nat_gateway = var.security_vpc_cfg.enable_nat_gateway
  single_nat_gateway = true

  tags = {
    Environment = var.environment
    VpcName     = local.security_vpc_name
  }
}


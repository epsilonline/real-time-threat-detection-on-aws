terraform {
  required_version = "~>1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }

  backend "http" {
    
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Terraform   = "true"
      ProjectName = var.project_name
      Environment = var.environment
    }
  }
}

locals {
  security_vpc_name = "${var.resource_name_prefix}-security-vpc"
  main_vpc_name     = "${var.resource_name_prefix}-main-vpc"
  protected_subnets = [for subnet in aws_subnet.protected_subnet : subnet]
}

data "aws_ami" "al2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }


  owners = ["amazon"]
}

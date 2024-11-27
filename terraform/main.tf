terraform {
  required_version = "~>1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }

  backend "http" {}
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

######################################
# Local variables
######################################

locals {
  security_vpc_name    = "${var.resource_name_prefix}-security-vpc"
  main_vpc_name        = "${var.resource_name_prefix}-main-vpc"
  protected_subnets    = [for subnet in aws_subnet.protected_subnet : subnet]
  trail_name           = "${var.resource_name_prefix}-wazuh-trail"
  wazuh_bucket_name    = "${var.resource_name_prefix}-wazuh-${random_string.random.result}"
  gwlbtun_bucket_name  = "${var.resource_name_prefix}-gwlb-${random_string.random.result}"
  gwlbtub_scripts_path = "${path.module}/../scripts"
  wazuh_ports          = ["1514", "1515", "1516", "514"]
}

######################################
# Data
######################################

data "aws_ami" "al2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }


  owners = ["amazon"]
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

######################################
# Random string
######################################

resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}
variable "resource_name_prefix" {
  type    = string
  default = "workshop-rttdoa"
}

variable "project_name" {
  type = string

  default = "real-time-threat-detection-on-aws"
}

variable "environment" {
  type = string

  default = "demo"
}

variable "region" {
  type = string

  default = "eu-west-1"
}

#######################################
# VPC
#######################################

variable "main_vpc_cfg" {
  type = object({
    azs               = list(string),
    cidr              = string
    private_subnets   = list(string)
    protected_subnets = list(string)
    public_subnets    = list(string)
  })
}

variable "security_vpc_cfg" {
  type = object({
    azs                = list(string),
    cidr               = string
    private_subnets    = list(string)
    public_subnets     = list(string)
    enable_nat_gateway = optional(bool, false) #required only for first launch
  })
}

#######################################
# VPC
#######################################

variable "monitored_instances" {
  type        = number
  description = "Number of monitored instances"
}
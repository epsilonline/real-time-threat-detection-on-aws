module "main_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name = local.main_vpc_name
  cidr = var.main_vpc_cfg.cidr

  azs             = var.main_vpc_cfg.azs
  private_subnets = var.main_vpc_cfg.private_subnets
  public_subnets  = var.main_vpc_cfg.public_subnets

  enable_nat_gateway = false
  single_nat_gateway = false

  tags = {
    VpcName = local.main_vpc_name
  }
}

resource "aws_route" "private_subnet_route_to_ngw" {
  for_each = toset(var.main_vpc_cfg.azs)

  route_table_id         = module.main_vpc.private_route_table_ids[index(var.main_vpc_cfg.azs, each.value)]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

######################################
# VPC Protected Subents
######################################
resource "aws_subnet" "protected_subnet" {
  for_each = toset(var.main_vpc_cfg.protected_subnets)

  vpc_id            = module.main_vpc.vpc_id
  cidr_block        = each.value
  availability_zone = length(regexall("^[a-z]{2}-", var.main_vpc_cfg.azs[index(var.main_vpc_cfg.protected_subnets, each.value)])) > 0 ? var.main_vpc_cfg.azs[index(var.main_vpc_cfg.protected_subnets, each.value)] : null
  tags = {
    Name    = "${local.main_vpc_name}-ProtectedSubnet-${var.main_vpc_cfg.azs[index(var.main_vpc_cfg.protected_subnets, each.value)]}"
    VpcName = local.main_vpc_name
  }
}

resource "aws_route_table" "protected_subnets" {

  vpc_id = module.main_vpc.vpc_id

  tags = {
    Name    = "${local.main_vpc_name}-ProtectedSubnet"
    VpcName = local.main_vpc_name
  }
}


resource "aws_route_table_association" "rt_association" {
  for_each = toset(var.main_vpc_cfg.protected_subnets)

  subnet_id      = aws_subnet.protected_subnet[each.key].id
  route_table_id = aws_route_table.protected_subnets.id
}


######################################
# Nat Gateway
######################################

resource "aws_eip" "main" {
  domain = "vpc"

  tags = {
    Name    = "${local.main_vpc_name}-NGW-EIP"
    VpcName = local.main_vpc_name
  }
}

resource "aws_nat_gateway" "main" {

  subnet_id     = local.protected_subnets[0].id
  allocation_id = aws_eip.main.id


  tags = {
    Name    = "${local.main_vpc_name}-NGW"
    VpcName = local.main_vpc_name
  }
}

######################################
# Outbound traffic inspection
######################################

resource "aws_route" "protected_subnet_firewall" {
  route_table_id         = aws_route_table.protected_subnets.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.main_vpc_inspection_endpoint.id

  depends_on = [aws_vpc_endpoint_connection_accepter.main_vpc_inspection_endpoint]
}


######################################
# Inbounbd traffic inspection
######################################
resource "aws_route_table" "inbound_inspection" {

  vpc_id = module.main_vpc.vpc_id

  tags = {
    Name    = "${local.main_vpc_name}-InboundInspection"
    VpcName = local.main_vpc_name
  }
}

resource "aws_route" "inspection_routes" {
  for_each = toset(var.main_vpc_cfg.protected_subnets)

  route_table_id         = aws_route_table.inbound_inspection.id
  destination_cidr_block = each.key
  vpc_endpoint_id        = aws_vpc_endpoint.main_vpc_inspection_endpoint.id

  depends_on = [aws_vpc_endpoint_connection_accepter.main_vpc_inspection_endpoint]
}

resource "aws_route_table_association" "inbound_inspection" {
  gateway_id     = module.main_vpc.igw_id
  route_table_id = aws_route_table.inbound_inspection.id
}

######################################
# Traffic inspection endpoint
######################################

resource "aws_vpc_endpoint" "main_vpc_inspection_endpoint" {

  vpc_id              = module.main_vpc.vpc_id
  service_name        = aws_vpc_endpoint_service.gwlb.service_name
  vpc_endpoint_type   = aws_vpc_endpoint_service.gwlb.service_type
  private_dns_enabled = false

  subnet_ids = [module.main_vpc.public_subnets[0]]
  tags = {
    Name    = "${var.resource_name_prefix}-NIDS-inspection"
    VpcName = local.main_vpc_name

  }
}

resource "aws_vpc_endpoint_connection_accepter" "main_vpc_inspection_endpoint" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.gwlb.id
  vpc_endpoint_id         = aws_vpc_endpoint.main_vpc_inspection_endpoint.id
}

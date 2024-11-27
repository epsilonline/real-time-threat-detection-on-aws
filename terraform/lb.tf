resource "aws_lb" "hids" {
  name               = "${var.resource_name_prefix}-ids"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.hids_nlb.id]
  subnets            = module.security_vpc.private_subnets

  enable_deletion_protection = true
}

resource "aws_lb_listener" "wazuh" {
  for_each          = toset(local.wazuh_ports)
  load_balancer_arn = aws_lb.hids.arn
  port              = each.key
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wazuh[each.key].arn
  }
}


resource "aws_lb_target_group" "wazuh" {
  for_each             = toset(local.wazuh_ports)
  name                 = "${var.resource_name_prefix}-wazuh-${each.key}"
  vpc_id               = module.security_vpc.vpc_id
  target_type          = "instance"
  protocol             = "TCP"
  port                 = each.key
  deregistration_delay = 300

  health_check {
    protocol            = "TCP"
    port                = each.key
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }
}

resource "aws_lb_target_group_attachment" "wazuh" {
  for_each = toset(local.wazuh_ports)

  target_group_arn = aws_lb_target_group.wazuh[each.key].arn
  target_id        = aws_instance.ids.id
  port             = each.key
}

resource "aws_security_group" "hids_nlb" {
  description = "Security group for hids nlb"
  vpc_id      = module.security_vpc.vpc_id
  name        = "${var.resource_name_prefix}-hids"
}

resource "aws_security_group_rule" "hids_agent_egress" {
  for_each = toset(local.wazuh_ports)

  type                     = "egress"
  protocol                 = "TCP"
  from_port                = each.key
  to_port                  = each.key
  security_group_id        = aws_security_group.hids_nlb.id
  source_security_group_id = aws_security_group.ids.id


  description = "Allow all egress"
}


resource "aws_security_group_rule" "hids_agent_ingress" {
  for_each = toset(local.wazuh_ports)

  type        = "ingress"
  protocol    = "TCP"
  cidr_blocks = ["0.0.0.0/0"]

  from_port         = each.key
  to_port           = each.key
  security_group_id = aws_security_group.hids_nlb.id

  description = "Allow agent connection from monitored instances"
}

resource "aws_vpc_endpoint_service" "hids" {
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.hids.arn]
  supported_ip_address_types = ["ipv4"]

  tags = {
    Name    = "${var.resource_name_prefix}-hids"
    VpcName = local.security_vpc_name
  }
}
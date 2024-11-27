######################################
# GWLB
######################################

resource "aws_lb" "gwlb" {
  name                             = "${var.resource_name_prefix}-NIDS-gwlb"
  load_balancer_type               = "gateway"
  enable_cross_zone_load_balancing = true
  subnets                          = module.security_vpc.private_subnets
  enable_deletion_protection       = false //to be true
}

resource "aws_lb_listener" "gwlb_listener" {
  load_balancer_arn = aws_lb.gwlb.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb_nids_tg.arn
  }
}

resource "aws_lb_target_group" "gwlb_nids_tg" {
  name                 = "${var.resource_name_prefix}-inspection"
  vpc_id               = module.security_vpc.vpc_id
  target_type          = "ip"
  protocol             = "GENEVE"
  port                 = "6081"
  deregistration_delay = 300

  health_check {
    protocol            = "TCP"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }

}

resource "aws_lb_target_group_attachment" "gwlb_tg_attachment" {

  target_group_arn = aws_lb_target_group.gwlb_nids_tg.arn
  target_id        = aws_instance.ids.private_ip
}

resource "aws_vpc_endpoint_service" "gwlb" {
  acceptance_required        = true
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
  supported_ip_address_types = ["ipv4"]

  tags = {
    Name    = "${var.resource_name_prefix}-NIDS-inspection"
    VpcName = local.security_vpc_name
  }
}


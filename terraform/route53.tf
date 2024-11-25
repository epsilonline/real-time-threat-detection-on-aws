######################################
# Route 53 private zone
######################################

resource "aws_route53_zone" "private_zone" {
  name = "${var.resource_name_prefix}.internal"

  vpc {
    vpc_id = module.main_vpc.vpc_id
  }
}

resource "aws_route53_record" "wazuh_host" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "wazuh.${var.resource_name_prefix}.internal"
  type    = "A"
  ttl     = "30"
  records = [aws_instance.wazuh.private_ip]
}
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

  alias {
    name                   = aws_vpc_endpoint.main_vpc_hids_endpoint.dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.main_vpc_hids_endpoint.dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }
}
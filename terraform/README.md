# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.76.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.76.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_main_vpc"></a> [main\_vpc](#module\_main\_vpc) | terraform-aws-modules/vpc/aws | 5.16.0 |
| <a name="module_security_vpc"></a> [security\_vpc](#module\_security\_vpc) | terraform-aws-modules/vpc/aws | 5.16.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.main](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/eip) | resource |
| [aws_iam_instance_profile.ec2_ssm_profile](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.iam_ec2_role](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.iam_policy_ec2_ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.dummy_nids](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/instance) | resource |
| [aws_instance.monitored](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/instance) | resource |
| [aws_key_pair.main](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/key_pair) | resource |
| [aws_lb.gwlb](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb) | resource |
| [aws_lb_listener.gwlb_listener](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.gwlb_nids_tg](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.gwlb_tg_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb_target_group_attachment) | resource |
| [aws_nat_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/nat_gateway) | resource |
| [aws_route.inspection_routes](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route) | resource |
| [aws_route.private_subnet_route_to_ngw](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route) | resource |
| [aws_route.protected_subnet_firewall](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route) | resource |
| [aws_route_table.inbound_inspection](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route_table) | resource |
| [aws_route_table.protected_subnets](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route_table) | resource |
| [aws_route_table_association.inbound_inspection](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_association](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route_table_association) | resource |
| [aws_security_group.dummy_nids](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.data_ingress_tcp](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.data_ingress_udp](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.https_egress](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_subnet.protected_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/subnet) | resource |
| [aws_vpc_endpoint.main_vpc_inspection_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_connection_accepter.main_vpc_inspection_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/vpc_endpoint_connection_accepter) | resource |
| [aws_vpc_endpoint_service.gwlb](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/vpc_endpoint_service) | resource |
| [aws_ami.al2023](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"demo"` | no |
| <a name="input_main_vpc_cfg"></a> [main\_vpc\_cfg](#input\_main\_vpc\_cfg) | n/a | <pre>object({<br>    azs               = list(string),<br>    cidr              = string<br>    private_subnets   = list(string)<br>    protected_subnets = list(string)<br>    public_subnets    = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_monitored_instances"></a> [monitored\_instances](#input\_monitored\_instances) | Number of monitored instances | `number` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `string` | `"real-time-threat-detection-on-aws"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-1"` | no |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix) | n/a | `string` | `"workshop-rttdoa"` | no |
| <a name="input_security_vpc_cfg"></a> [security\_vpc\_cfg](#input\_security\_vpc\_cfg) | n/a | <pre>object({<br>    azs                = list(string),<br>    cidr               = string<br>    private_subnets    = list(string)<br>    public_subnets     = list(string)<br>    enable_nat_gateway = optional(bool, false) #required only for first launch<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

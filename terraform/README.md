# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.76.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.76.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_main_vpc"></a> [main\_vpc](#module\_main\_vpc) | terraform-aws-modules/vpc/aws | 5.16.0 |
| <a name="module_security_vpc"></a> [security\_vpc](#module\_security\_vpc) | terraform-aws-modules/vpc/aws | 5.16.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.trail](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/cloudtrail) | resource |
| [aws_eip.main](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/eip) | resource |
| [aws_guardduty_detector.this](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/guardduty_detector) | resource |
| [aws_iam_instance_profile.ec2_gwlbtun](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_instance_profile.ec2_wazuh](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_instance_profile.iam_ec2_role](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.gwlbtub_s3](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.wazuh_s3](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.ec2_gwlbtun](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role) | resource |
| [aws_iam_role.ec2_wazuh](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role) | resource |
| [aws_iam_role.iam_ec2_role](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.gwlbtub_s3](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_policy_ec2_ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_policy_gwlbtub_ec2_ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_policy_wazuh_ec2_ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ids_wazuh_s3](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.wazuh_s3](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_inspector2_enabler.this](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/inspector2_enabler) | resource |
| [aws_instance.ids](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/instance) | resource |
| [aws_instance.monitored](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/instance) | resource |
| [aws_key_pair.main](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/key_pair) | resource |
| [aws_lb.gwlb](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb) | resource |
| [aws_lb.hids](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb) | resource |
| [aws_lb_listener.gwlb_listener](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.wazuh](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.gwlb_nids_tg](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.wazuh](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.gwlb_tg_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.wazuh](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/lb_target_group_attachment) | resource |
| [aws_nat_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/nat_gateway) | resource |
| [aws_route.inspection_routes](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route) | resource |
| [aws_route.private_subnet_route_to_ngw](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route) | resource |
| [aws_route.protected_subnet_firewall](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route) | resource |
| [aws_route53_record.wazuh_host](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route53_zone) | resource |
| [aws_route_table.inbound_inspection](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route_table) | resource |
| [aws_route_table.protected_subnets](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route_table) | resource |
| [aws_route_table_association.inbound_inspection](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_association](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.gwlbtun](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.wazuh_cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.allow_trail_access](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_object.gwlbtub_scripts](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/s3_object) | resource |
| [aws_security_group.hids_nlb](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group) | resource |
| [aws_security_group.hids_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group) | resource |
| [aws_security_group.ids](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group) | resource |
| [aws_security_group.monitored_instances](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.data_ingress_tcp](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.data_ingress_udp](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.hids_agent_egress](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.hids_agent_ingress](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.hids_vpc_endpoint_ingress](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.https_egress](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitored_egress](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.udp_egress](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.wazuh_agent_from_nlb_ingress](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group_rule) | resource |
| [aws_securityhub_account.account](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/securityhub_account) | resource |
| [aws_subnet.protected_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/subnet) | resource |
| [aws_vpc_endpoint.main_vpc_hids_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.main_vpc_inspection_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_connection_accepter.main_vpc_ids_inspection_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/vpc_endpoint_connection_accepter) | resource |
| [aws_vpc_endpoint_connection_accepter.main_vpc_inspection_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/vpc_endpoint_connection_accepter) | resource |
| [aws_vpc_endpoint_security_group_association.ids_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/vpc_endpoint_security_group_association) | resource |
| [aws_vpc_endpoint_service.gwlb](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/vpc_endpoint_service) | resource |
| [aws_vpc_endpoint_service.hids](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/vpc_endpoint_service) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/string) | resource |
| [aws_ami.al2023](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_trail_access](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"demo"` | no |
| <a name="input_extra_ec2_tags"></a> [extra\_ec2\_tags](#input\_extra\_ec2\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_main_vpc_cfg"></a> [main\_vpc\_cfg](#input\_main\_vpc\_cfg) | n/a | <pre>object({<br>    azs               = list(string),<br>    cidr              = string<br>    private_subnets   = list(string)<br>    protected_subnets = list(string)<br>    public_subnets    = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_monitored_instances"></a> [monitored\_instances](#input\_monitored\_instances) | Number of monitored instances | `number` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `string` | `"real-time-threat-detection-on-aws"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-1"` | no |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix) | n/a | `string` | `"workshop-rttdoa"` | no |
| <a name="input_security_vpc_cfg"></a> [security\_vpc\_cfg](#input\_security\_vpc\_cfg) | n/a | <pre>object({<br>    azs                = list(string),<br>    cidr               = string<br>    private_subnets    = list(string)<br>    public_subnets     = list(string)<br>    enable_nat_gateway = optional(bool, false) #required only for first launch<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_wazuh_dashboard_access"></a> [wazuh\_dashboard\_access](#output\_wazuh\_dashboard\_access) | n/a |
| <a name="output_wazuh_host_fqdn"></a> [wazuh\_host\_fqdn](#output\_wazuh\_host\_fqdn) | n/a |
| <a name="output_wazuh_trail_bucket"></a> [wazuh\_trail\_bucket](#output\_wazuh\_trail\_bucket) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

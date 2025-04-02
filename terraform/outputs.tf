output "wazuh_dashboard_access" {
  value = "aws ssm start-session --target ${aws_instance.ids.id} --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{\"portNumber\":[\"443\"],\"localPortNumber\":[\"8443\"],\"host\":[\"127.0.0.1\"]}'"
}

output "wazuh_access" {
  value = "aws ssm start-session --target ${aws_instance.ids.id}"
}

output "monitered_ec2_instances_access" {
  value = [for id in aws_instance.monitored[*].id : format("aws ssm start-session --target %s", id)]
}

output "wazuh_host_fqdn" {
  value = aws_route53_record.wazuh_host.fqdn
}

output "wazuh_trail_bucket" {
  value = aws_s3_bucket.wazuh_cloudtrail.id
}

output "monitered_ec2_instance_ids" {
  value = aws_instance.monitored[*].id
}
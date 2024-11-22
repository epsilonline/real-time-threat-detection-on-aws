output "wazuh_dashboard_access" {
  value = "aws ssm start-session --target ${aws_instance.wazuh.id} --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{\"portNumber\":[\"443\"],\"localPortNumber\":[\"8443\"],\"host\":[\"127.0.0.1\"]}'"
}
######################################
# GWLB Tun
######################################
resource "aws_instance" "monitored" {
  count                   = var.monitored_instances
  ami                     = data.aws_ami.al2023.id
  iam_instance_profile    = aws_iam_role.iam_ec2_role.name
  instance_type           = "t3.micro"
  key_name                = aws_key_pair.main.key_name
  disable_api_termination = true
  ebs_optimized           = true
  monitoring              = true
  source_dest_check       = true

  vpc_security_group_ids = [aws_security_group.monitored_instances.id]


  subnet_id = element(module.main_vpc.private_subnets, 0) #Same subnet as paloalto instance

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data = base64encode("")

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp3"
    iops                  = 3000
  }

  tags = merge({ "Name" : "${var.resource_name_prefix}-monitored-${count.index}" })

  lifecycle {
    ignore_changes = [ami]
  }
}


resource "aws_security_group" "monitored_instances" {
  description = "Security group for monitered instances"
  vpc_id      = module.main_vpc.vpc_id
  name        = "${var.resource_name_prefix}-monitored-instances"
}

resource "aws_security_group_rule" "monitored_egress" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "-1"
  to_port           = 65535
  from_port         = 0
  security_group_id = aws_security_group.monitored_instances.id

  description = "Allow all egress"
}

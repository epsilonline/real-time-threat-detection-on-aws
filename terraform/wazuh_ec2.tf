######################################
# GWLB Tun
######################################
resource "aws_instance" "wazuh" {
  ami                     = data.aws_ami.al2023.id
  iam_instance_profile    = aws_iam_role.iam_ec2_role.name
  instance_type           = "t3.large"
  key_name                = aws_key_pair.main.key_name
  disable_api_termination = true
  ebs_optimized           = true
  monitoring              = true
  source_dest_check       = true

  vpc_security_group_ids = [aws_security_group.wazuh_instance.id]


  subnet_id = element(module.main_vpc.private_subnets, 0) #Same subnet as paloalto instance

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data = base64encode(
    <<EOF
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0
 
--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cloud-config.txt"
 
#cloud-config
cloud_final_modules:
- [scripts-user, always]
--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash

# install docker
yum update
yum install -y docker git

# Install docker-compose
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

systemctl enable docker
systemctl start docker

# start wazuh
cd /root
git clone https://github.com/wazuh/wazuh-docker.git -b v4.9.2
cd wazuh-docker/single-node/
docker-compose -f generate-indexer-certs.yml run --rm generator
# docker-compose up -d 
--//--
EOF
  )

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp3"
    iops                  = 3000
  }

  tags = merge({ "Name" : "${var.resource_name_prefix}-wazuh-surricata" }, var.extra_ec2_tags)

  lifecycle {
    ignore_changes = [ami]
  }
}


resource "aws_security_group" "wazuh_instance" {
  description = "Security group for monitered instances"
  vpc_id      = module.main_vpc.vpc_id
  name        = "${var.resource_name_prefix}-wazuh-instances"
}

resource "aws_security_group_rule" "wazuh_egress" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "TCP"
  to_port           = 443
  from_port         = 443
  security_group_id = aws_security_group.wazuh_instance.id

  description = "Allow all egress"
}

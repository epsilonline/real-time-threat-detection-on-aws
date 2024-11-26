######################################
# GWLB Tun
######################################
resource "aws_instance" "dummy_nids" {

  ami                     = data.aws_ami.al2023.id
  iam_instance_profile    = aws_iam_role.ec2_gwlbtun.name
  instance_type           = "t3.micro"
  key_name                = aws_key_pair.main.key_name
  disable_api_termination = true
  ebs_optimized           = true
  monitoring              = true
  source_dest_check       = true

  vpc_security_group_ids = [aws_security_group.dummy_nids.id]


  subnet_id = element(module.security_vpc.private_subnets, 0)

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
        #!/bin/bash -ex
          yum -y groupinstall "Development Tools"
          yum -y install cmake3
          yum -y install tc || true
          yum -y install iproute-tc || true
          cd /root
          git clone https://github.com/aws-samples/aws-gateway-load-balancer-tunnel-handler.git
          cd aws-gateway-load-balancer-tunnel-handler
          cmake3 .
          make

          aws s3 sync s3://${aws_s3_bucket.gwlbtun.id}/ example-scripts/
          chmod +x -R example-scripts/*.sh

          echo "[Unit]" > /usr/lib/systemd/system/gwlbtun.service
          echo "Description=AWS GWLB Tunnel Handler" >> /usr/lib/systemd/system/gwlbtun.service
          echo "" >> /usr/lib/systemd/system/gwlbtun.service
          echo "[Service]" >> /usr/lib/systemd/system/gwlbtun.service
          echo "ExecStart=/root/aws-gateway-load-balancer-tunnel-handler/gwlbtun -c /root/aws-gateway-load-balancer-tunnel-handler/example-scripts/create-passthrough.sh -p 80" >> /usr/lib/systemd/system/gwlbtun.service
          echo "Restart=always" >> /usr/lib/systemd/system/gwlbtun.service
          echo "RestartSec=5s" >> /usr/lib/systemd/system/gwlbtun.service
          echo "[Install]" >> /usr/lib/systemd/system/gwlbtun.service
          echo "WantedBy=multi-user.target" >> /usr/lib/systemd/system/gwlbtun.service

          systemctl daemon-reload
          systemctl enable --now --no-block gwlbtun.service
          systemctl start gwlbtun.service
          echo
          --//--
        EOF
  )

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp3"
    iops                  = 3000
  }

  tags = merge({ "Name" : "${var.resource_name_prefix}-dummy-nids" }, var.extra_ec2_tags)

  lifecycle {
    ignore_changes = [ami]
  }
}



resource "aws_security_group" "dummy_nids" {
  description = "Dummy NIDS security group"
  vpc_id      = module.security_vpc.vpc_id
  name        = "${var.resource_name_prefix}-dummy-nids"
}

resource "aws_security_group_rule" "data_ingress_udp" {
  type              = "ingress"
  cidr_blocks       = module.security_vpc.private_subnets_cidr_blocks
  protocol          = "UDP"
  to_port           = 6081
  from_port         = 6081
  security_group_id = aws_security_group.dummy_nids.id

  description = "Allow traffic inspection"
}

resource "aws_security_group_rule" "data_ingress_tcp" {
  type              = "ingress"
  cidr_blocks       = module.security_vpc.private_subnets_cidr_blocks
  protocol          = "TCP"
  to_port           = 80
  from_port         = 80
  security_group_id = aws_security_group.dummy_nids.id

  description = "Allow healthcheck from gwlb"
}

resource "aws_security_group_rule" "https_egress" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "TCP"
  to_port           = 443
  from_port         = 443
  security_group_id = aws_security_group.dummy_nids.id

  description = "Allow packages download"
}

resource "aws_security_group_rule" "udp_egress" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "UDP"
  to_port           = 65535
  from_port         = 0
  security_group_id = aws_security_group.dummy_nids.id

  description = "Allow egress traffic to gwlb"
}

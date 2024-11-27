######################################
# GWLB Tun
######################################
resource "aws_instance" "ids" {

  ami                     = data.aws_ami.al2023.id
  iam_instance_profile    = aws_iam_role.ec2_gwlbtun.name
  instance_type           = "t3.large"
  key_name                = aws_key_pair.main.key_name
  disable_api_termination = true
  ebs_optimized           = true
  monitoring              = true
  source_dest_check       = true

  vpc_security_group_ids = [aws_security_group.ids.id]


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

          ######################################
          # GWLB Tun
          ######################################

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

          ######################################
          # Wazuh
          ######################################

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
          docker-compose up -d

          ######################################
          # Suricata
          ######################################
          yum install -y pcre2-devel libyaml-devel jansson-devel libpcap-devel rustc cargo
          wget -O suricata.tar.gz https://www.openinfosecfoundation.org/download/suricata-7.0.7.tar.gz
          tar xzvf suricata.tar.gz -C suricata
          cd suricata
          ./configure
          make
          make install
          cd /root
          mkdir -p /etc/suricata/
          mv suricata/suricata.yaml /etc/suricata/suricata.yaml
          mkdir /var/log/suricata/

          cd /tmp/ && curl -LO https://rules.emergingthreats.net/open/suricata-6.0.8/emerging.rules.tar.gz
          sudo tar -xvzf emerging.rules.tar.gz && sudo mkdir /etc/suricata/rules && sudo mv rules/*.rules /etc/suricata/rules/
          sudo chmod 640 /etc/suricata/rules/*.rules

          echo "[Unit]" > /usr/lib/systemd/system/suricata.service
          echo "Description=Suricata" >> /usr/lib/systemd/system/suricata.service
          echo "" >> /usr/lib/systemd/system/suricata.service
          echo "[Service]" >> /usr/lib/systemd/system/suricata.service
          echo "ExecStart=/usr/local/bin/suricata -i ens5 -c /etc/suricata/suricata.yaml" >>
          echo "Restart=always" >> /usr/lib/systemd/system/suricata.service
          echo "RestartSec=5s" >> /usr/lib/systemd/system/suricata.service
          echo "[Install]" >> /usr/lib/systemd/system/suricata.service
          echo "WantedBy=multi-user.target" >> /usr/lib/systemd/system/suricata.service

          systemctl daemon-reload
          systemctl enable --now --no-block suricata.service
          systemctl start suricata.service


          echo
          --//--
        EOF
  )

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp3"
    iops                  = 3000
  }

  tags = merge({ "Name" : "${var.resource_name_prefix}-ids" }, var.extra_ec2_tags)

  lifecycle {
    ignore_changes = [ami]
  }
}


resource "aws_security_group" "ids" {
  description = "IDS security group"
  vpc_id      = module.security_vpc.vpc_id
  name        = "${var.resource_name_prefix}-ids"
}

resource "aws_security_group_rule" "data_ingress_udp" {
  type              = "ingress"
  cidr_blocks       = module.security_vpc.private_subnets_cidr_blocks
  protocol          = "UDP"
  to_port           = 6081
  from_port         = 6081
  security_group_id = aws_security_group.ids.id

  description = "Allow traffic inspection"
}

resource "aws_security_group_rule" "data_ingress_tcp" {
  type              = "ingress"
  cidr_blocks       = module.security_vpc.private_subnets_cidr_blocks
  protocol          = "TCP"
  to_port           = 80
  from_port         = 80
  security_group_id = aws_security_group.ids.id

  description = "Allow healthcheck from gwlb"
}

resource "aws_security_group_rule" "https_egress" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "TCP"
  to_port           = 443
  from_port         = 443
  security_group_id = aws_security_group.ids.id

  description = "Allow packages download"
}

resource "aws_security_group_rule" "udp_egress" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "UDP"
  to_port           = 65535
  from_port         = 0
  security_group_id = aws_security_group.ids.id

  description = "Allow egress traffic to gwlb"
}


resource "aws_security_group_rule" "wazuh_agent_from_nlb_ingress" {
  for_each = toset(local.wazuh_ports)

  type     = "ingress"
  protocol = "TCP"

  from_port                = each.key
  to_port                  = each.key
  security_group_id        = aws_security_group.ids.id
  source_security_group_id = aws_security_group.hids_nlb.id


  description = "Allow connection from nlb on wazuh agent ports"
}
# Real-Time Threat Detection on AWS - Scripts

This directory contains utility scripts for demonstrating and managing the Real-Time Threat Detection on AWS solution. These scripts help you visualize and test various security features implemented in the architecture.

## Available Scripts

### 1. `glwbtub-demo-rules.sh`

This script sets up traffic control rules for the Gateway Load Balancer Tunnel (GWLB) to demonstrate network traffic filtering:

- Blocks ICMP (ping) traffic
- Blocks ingress traffic on port 80
- Configures traffic mirroring between interfaces

Usage:

```bash
./glwbtub-demo-rules.sh [mode] [input_interface] [output_interface] [eni]
```

### 2. `malware_demo.sh`

Demonstrates the anti-malware scanning capabilities by monitoring SQS queues for scan events:

- Creates a tmux session with multiple panes
- Monitors the Bucket AV SQS queue for file scanning events
- Monitors the GuardDuty Antimalware SQS queue for scanning events

Usage:

```bash
./malware_demo.sh
```

Requirements:

- Python script for consuming SQS messages

### 3. `manage-firewall.sh`

Manages the GWLB tunnel firewall service by enabling or disabling filtering rules:

- Creates and configures the systemd service file for the GWLB tunnel handler
- Toggles between filtering mode and passthrough mode

Usage:

```bash
./manage-firewall.sh [enable|disable]
```

### 4. `traffic_demo.sh`

Demonstrates network traffic filtering by setting up a monitoring environment:

- Creates a tmux session with multiple panes
- Monitors dmesg logs for blocked traffic
- Monitors ingress and egress packets on GWLB tunnel interfaces
- Initiates test traffic (ping and HTTP requests) from monitored instances

Usage:

```bash
./traffic_demo.sh
```

Requirements:

- SSM access to the specified EC2 instances

### 5. `wazuh_demo.sh`

Demonstrates Wazuh security monitoring and a simulated brute force attack:

- Sets up port forwarding to access the Wazuh dashboard
- Deploys and starts the Wazuh Docker environment
- Installs Wazuh agents on monitored instances
- Simulates an SSH brute force attack between monitored instances
- Monitors audit logs for detection

Usage:

```bash
./wazuh_demo.sh
```

Requirements:

- SSM access to the specified EC2 instances
- Docker installed on the IDS instance

## Prerequisites

Before running these scripts, ensure you have:

1. Deployed the infrastructure using the Terraform templates in the parent directory
2. Configured AWS CLI with appropriate credentials
3. Required permissions to access the EC2 instances via SSM
4. tmux installed on your local machine

## Usage Notes

- The scripts assume specific EC2 instance IDs. Update these IDs if your instances are different.
- For the Wazuh demo, ensure you have followed the Wazuh configuration steps in the main README.

## Troubleshooting

- If a tmux session already exists with the same name, the scripts will exit with an error. Kill the existing session first.
- If monitored instances cannot connect to the internet, check if the GWLB tunnel service is running on the IDS machine.
- For any AWS permission issues, verify your IAM permissions and AWS profile configuration.

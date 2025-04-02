#!/bin/bash

# Check if an argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 [enable|disable]"
    exit 1
fi

SERVICE_FILE="/usr/lib/systemd/system/gwlbtun.service"
BASE_COMMAND="/root/aws-gateway-load-balancer-tunnel-handler/gwlbtun"
ENABLE_SCRIPT="/root/aws-gateway-load-balancer-tunnel-handler/example-scripts/glwbtun-demo-rules.sh"
DISABLE_SCRIPT="/root/aws-gateway-load-balancer-tunnel-handler/example-scripts/create-passthrough.sh"

# Function to create the service file
create_service_file() {
    local exec_command="$1"

    cat > "$SERVICE_FILE" << EOL
[Unit]
Description=GWLB Tunnel Handler Service
After=network.target

[Service]
Type=simple
ExecStart=${exec_command}
Restart=always

[Install]
WantedBy=multi-user.target
EOL
}

# Main logic
case "$1" in
    "enable")
        create_service_file "${BASE_COMMAND} -c ${ENABLE_SCRIPT} -p 80"
        echo "Firewall enabled in GWLB tunnel service"
        ;;
    "disable")
        create_service_file "${BASE_COMMAND} -c ${DISABLE_SCRIPT} -p 80"
        echo "Firewall disabled in GWLB tunnel service"
        ;;
    *)
        echo "Invalid argument. Use 'enable' or 'disable'"
        exit 1
        ;;
esac

# Reload systemd to recognize changes and restart the service
systemctl daemon-reload
systemctl restart gwlbtun.service

# Show status of the service
systemctl status gwlbtun.service

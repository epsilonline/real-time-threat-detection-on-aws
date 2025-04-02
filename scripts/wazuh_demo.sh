#! /bin/bash

# Configure AWS Profile
AWS_PROFILE="epsilonlab"

# Nome della sessione tmux
SESSION_NAME="wazuh_demo"

# Array di ID delle istanze EC2
IDS_INSTANCE="i-0c247234be74761b4"
MONITORED_INSTANCES=( "i-086ec974a5da55ee7" "i-02a88bd2aa4f3a965" )
MONITORED_INSTANCES_LENGTH=${#MONITORED_INSTANCES[@]}

# Controlla se la sessione esiste già
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "La sessione tmux '$SESSION_NAME' esiste già."
    exit 1
fi

# Crea una nuova sessione tmux in background
tmux new-session -d -s $SESSION_NAME

# Dividi la finestra in 4 pannelli
tmux split-window -h   # Divide in due colonne

tmux select-pane -t 0
tmux split-window -v   # Divide in due righe a sinistra

tmux select-pane -t 2
tmux split-window -v   # Divide in due righe a sinistra

for i in {0..3}; do
    tmux select-pane -t $i
    tmux send-keys "export AWS_PROFILE=${AWS_PROFILE}" C-m
done

# Monitor dmesg logs
tmux select-pane -t 0
tmux send-keys "aws ssm start-session --target ${IDS_INSTANCE} --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{\"portNumber\":[\"443\"],\"localPortNumber\":[\"8443\"],\"host\":[\"127.0.0.1\"]}'" C-m

tmux select-pane -t 1
tmux send-keys "aws ssm start-session --target ${IDS_INSTANCE}" C-m
tmux send-keys "sudo bash" C-m
tmux send-keys "cd /root/wazuh-docker/single-node/" C-m
tmux send-keys "docker-compose up" C-m


# Target ip for brute force attach
ATTACKER_INSTANCE=0
TARGET_INSTANCE=1
TARGET_IP=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=instance-id,Values=${MONITORED_INSTANCES[${TARGET_INSTANCE}]}" --query 'Reservations[*].Instances[*].[PrivateIpAddress]' --output text)

# Configure attacker instance
tmux select-pane -t 2
tmux send-keys "aws ssm start-session --target ${MONITORED_INSTANCES[$ATTACKER_INSTANCE]}" C-m
tmux send-keys "sudo bash" C-m
tmux send-keys "curl -o wazuh-agent-4.9.2-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.9.2-1.x86_64.rpm && sudo WAZUH_MANAGER='wazuh.workshop-rttdoa.internal' WAZUH_AGENT_NAME='${MONITORED_INSTANCES[$i]}' rpm -ihv wazuh-agent-4.9.2-1.x86_64.rpm" C-m
sleep 5
tmux select-pane -t 2
tmux send-keys "systemctl daemon-reload" C-m
tmux send-keys "systemctl enable wazuh-agent" C-m
tmux send-keys "systemctl start wazuh-agent" C-m
tmux send-keys "cd /root" C-m
tmux send-keys "wget -O list.txt https://raw.githubusercontent.com/duyet/bruteforce-database/refs/heads/master/38650-username-sktorrent.txt" C-m
sleep 1
tmux select-pane -t 2
tmux send-keys "yum install -y docker" C-m
tmux send-keys "systemctl enable docker && systemctl start docker" C-m
sleep 1
tmux select-pane -t 2
tmux send-keys "docker run -it --rm -v ~:/usr/share/wordlists secsi/hydra -l ec2-user -P /usr/share/wordlists/list.txt ssh://${TARGET_IP}" C-m

# Configure attacker instance
tmux select-pane -t 3
tmux send-keys "aws ssm start-session --target ${MONITORED_INSTANCES[$TARGET_INSTANCE]}" C-m
tmux send-keys "sudo bash" C-m
tmux send-keys "curl -o wazuh-agent-4.9.2-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.9.2-1.x86_64.rpm && sudo WAZUH_MANAGER='wazuh.workshop-rttdoa.internal' WAZUH_AGENT_NAME='${MONITORED_INSTANCES[$i]}' rpm -ihv wazuh-agent-4.9.2-1.x86_64.rpm" C-m
sleep 5
tmux send-keys "systemctl daemon-reload" C-m
tmux send-keys "systemctl enable wazuh-agent" C-m
tmux send-keys "systemctl start wazuh-agent" C-m
tmux send-keys "sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config" C-m
tmux send-keys "systemctl restart sshd" C-m
sleep 1
tmux send-keys "tail -f /var/log/audit/audit.log" C-m

# Attacca alla sessione
tmux select-pane -t 0  # Seleziona il primo pannello
tmux attach-session -t $SESSION_NAME


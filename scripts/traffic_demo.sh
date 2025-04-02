#! /bin/bash

# Configure AWS Profile
AWS_PROFILE="epsilonlab"

# Nome della sessione tmux
SESSION_NAME="traffic_demo"

# Array di ID delle istanze EC2
IDS_INSTANCE="i-0c247234be74761b4"
MONITORED_INSTANCES=( "i-086ec974a5da55ee7" "i-02a88bd2aa4f3a965" )

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

tmux select-pane -t 1
tmux split-window -v   # Divide in due righe a sinistra

tmux select-pane -t 3
tmux split-window -v   # Divide in due righe a destra

for i in {0..4}; do
    tmux select-pane -t $i
    tmux send-keys "export AWS_PROFILE=${AWS_PROFILE}" C-m
done

# Monitor dmesg logs
tmux select-pane -t 0
tmux send-keys "aws ssm start-session --target ${IDS_INSTANCE}" C-m
tmux send-keys "sudo bash" C-m
tmux send-keys "export PATH=\$PATH:/root/aws-gateway-load-balancer-tunnel-handler/examples-scripts" C-m
tmux send-keys "sudo dmesg -W | grep Block" C-m

# Monitor ingress packets
tmux select-pane -t 1
tmux send-keys "aws ssm start-session --target ${IDS_INSTANCE}" C-m
tmux send-keys "INTERFACE=\$(ip -o link show | awk -F': ' '{print \$2}' | grep -E '^gwi')" C-m
tmux send-keys "sudo tcpdump -i \$INTERFACE -nn -s 0 -c 100" C-m

# Monitor egress packets
tmux select-pane -t 2
tmux send-keys "aws ssm start-session --target ${IDS_INSTANCE}" C-m
tmux send-keys "INTERFACE=\$(ip -o link show | awk -F': ' '{print \$2}' | grep -E '^gwo')" C-m
tmux send-keys "sudo tcpdump -i \$INTERFACE -nn -s 0 -c 100" C-m

tmux select-pane -t 3
tmux send-keys "aws ssm start-session --target ${MONITORED_INSTANCES[0]}" C-m
tmux send-keys "ping google.com" C-m

tmux select-pane -t 4
tmux send-keys "aws ssm start-session --target ${MONITORED_INSTANCES[1]}" C-m
tmux send-keys "watch curl http://google.com" C-m


# Attacca alla sessione
tmux select-pane -t 0  # Seleziona il primo pannello
tmux attach-session -t $SESSION_NAME

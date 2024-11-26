#!/bin/bash

echo "==> Setting up example with this rules"
echo "- Block ping"
echo "- Block ingress on 80"


echo Mode is $1, In Int is $2, Out Int is $3, ENI is $4

tc qdisc add dev $2 ingress


# block icmp
tc filter add dev $2 parent ffff: protocol ip prio 1 u32 match ip protocol 1 0xff flowid 1:1 action simple sdata "Block ICMP"
tc filter add dev $2 parent ffff: protocol ip prio 2 u32 match ip protocol 1 0xff flowid 1:1 action drop

# block 80
tc filter add dev $2 parent ffff: protocol all prio 3 u32 match ip dport 80 0xff flowid 1:1 action simple sdata "Block port 80"
tc filter add dev $2 parent ffff: protocol all prio 4 u32 match ip dport 80 0xff flowid :1 action drop

# passthrough
tc filter add dev $2 parent ffff: protocol all prio 5 u32 match u32 0 0 flowid 1:1 action mirred egress mirror dev $3

echo "Configuration it's done, firewall it's up!"
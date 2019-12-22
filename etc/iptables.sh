#!/usr/bin/env bash

SSH_PORT=1
IF=eth0
SERVER_IP=$(ip addr show $IF | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

iptables -F
iptables -X

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow unlimited traffic on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow incoming ssh only
iptables    -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 \
            --dport $SSH_PORT -m state --state NEW,ESTABLISHED -j ACCEPT

iptables    -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport $SSH_PORT \
            --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT

# make sure nothing comes or goes out of this box
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

#!/usr/bin/env bash

SSH_PORT=1
IF=eth0
SERVER_IP=$(ip addr show $IF | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

DNS_SERVER="100.100.100.16 100.100.100.17"

# Whitelist of domains
PACKAGE_SERVER=$(cat <<-END
us.archive.ubuntu.com
archive.canonical.com
security.ubuntu.com
www.github.com
github.com
140.82.113.3
192.30.255.113
140.82.114.3
END
)

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

for ip in $DNS_SERVER
do
	echo "Allowing DNS lookups (tcp, udp port 53) to server '$ip'"
	iptables -A OUTPUT -p udp -d $ip --dport 53 -m state \
             --state NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT  -p udp -s $ip --sport 53 -m state \
             --state ESTABLISHED     -j ACCEPT
	iptables -A OUTPUT -p tcp -d $ip --dport 53 -m state \
             --state NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT  -p tcp -s $ip --sport 53 -m state \
             --state ESTABLISHED     -j ACCEPT
done

# Allow unlimited traffic on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

for ip in $PACKAGE_SERVER
do
	echo "Allow connection to '$ip' on port 21"
	iptables -A OUTPUT -p tcp -d "$ip" --dport 21  -m state \
             --state NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT  -p tcp -s "$ip" --sport 21  -m state \
             --state ESTABLISHED     -j ACCEPT

    echo "Allow connection to '$ip' on port 22"
	iptables -A OUTPUT -p tcp -d "$ip" --dport 22  -m state \
             --state NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT  -p tcp -s "$ip" --sport 22  -m state \
             --state ESTABLISHED     -j ACCEPT

	echo "Allow connection to '$ip' on port 80"
	iptables -A OUTPUT -p tcp -d "$ip" --dport 80  -m state \
             --state NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT  -p tcp -s "$ip" --sport 80  -m state \
             --state ESTABLISHED     -j ACCEPT

	echo "Allow connection to '$ip' on port 443"
	iptables -A OUTPUT -p tcp -d "$ip" --dport 443 -m state \
             --state NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT  -p tcp -s "$ip" --sport 443 -m state \
             --state ESTABLISHED     -j ACCEPT
done

# Allow incoming ssh only
iptables    -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 \
            --dport $SSH_PORT -m state --state NEW,ESTABLISHED -j ACCEPT

iptables    -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport $SSH_PORT \
            --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT

# Allow port 80 and 443
iptables    -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 \
            --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

iptables    -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 80 \
            --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT

iptables    -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 \
            --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT

iptables    -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 443 \
            --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT

# make sure nothing comes or goes out of this box
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

#!/bin/bash

#Enable portforwarding, by changing the address/port from that received on router, to what the server is actually using
#Port 161 chosen since VK :)
iptables -t nat -A PREROUTING -p tcp -i wlp45s0 --dport 80 -j DNAT --to-destination 192.168.0.2:161

#This is to ensure correct forwarding of TCP connections involved
iptables -A FORWARD -p tcp -d 192.168.0.2 --dport 161 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

echo "Done"

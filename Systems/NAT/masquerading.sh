#!/bin/bash

#Enable forwarding on host
echo 1 > /proc/sys/net/ipv4/ip_forward

#Set up action masquerading on host NAT table; POSTROUTING => to do the subnet address-mapping after routing decision taken.
sudo iptables -t nat -A POSTROUTING -s 192.168.0.0/255.255.255.0 -o wlp45s0 -j MASQUERADE
                                                                    #CHANGE REQD!!!

#Enable forwarding on the veth, in the filter table...
sudo iptables -A FORWARD -i wlp45s0 -o vethR -j ACCEPT
                            #CHANGE REQD!!!

#... in both directions
sudo iptables -A FORWARD -o wlp45s0 -i vethR -j ACCEPT
                            #CHANGE REQD!!!

echo "Done"
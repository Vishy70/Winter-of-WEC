#!/bin/bash

#Allow HTTP and HTTPS connections
iptables -A FORWARD -p tcp -s 192.168.0.2  --dport 80 -o wlp45s0 -j ACCEPT
                                                        #CHANGE REQD!!!

iptables -A FORWARD -p tcp -s 192.168.0.2 --dport 443 -o wlp45s0 -j ACCEPT
                                                        #CHANGE REQD!!!

#Enable specifically tcp related connection/transmission packets to be transferrable
iptables -A FORWARD -d 192.168.0.2 -m state --state ESTABLISHED,RELATED -j ACCEPT

#Deny all else, like ping, ftp, etc.
iptables -A FORWARD -s 192.168.0.2 -o wlp45s0 -j REJECT
                                    #CHANGE REQD!!!
                                    
echo "Done"



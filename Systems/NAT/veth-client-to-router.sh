#!/bin/bash

#Please make sure this script is excuted in the client net-namespace.
#Run the command below in a terminal:
#sudo ip netns exec client /bin/bash

#Bringing up loopback, just for testing
sudo ip link set dev lo up

#Assign ip to this connection's interface
sudo ip addr add 192.168.0.2/24 dev vethC

#Bring up connection (like bringing up L3 device in CPT)
sudo ip link set dev vethC up

#Setup DEFAULT GATEWAY as the ROUTER/HOST!
sudo ip route add default via 192.168.0.1

echo "Done"
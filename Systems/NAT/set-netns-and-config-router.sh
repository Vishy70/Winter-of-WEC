#!/bin/bash

#Command to create a new network namespace
sudo ip netns add client

#setting up virtual-ethernet pair
sudo ip link add vethC type veth peer name vethR

#set up the interface on the 'client'
#No such step for 'router' since already in the default namespace initially
sudo ip link set vethC netns client

#Assign ip to this connection's interface
sudo ip a add 192.168.0.1/24 dev vethR

#Bring up connection (like bringing up L3 device in CPT)
sudo ip link set dev vethR up

echo "Done"


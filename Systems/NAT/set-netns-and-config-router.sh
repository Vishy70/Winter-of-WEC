#!/bin/bash

sudo ip netns add client

sudo ip link add vethC type veth peer name vethR
sudo ip link set vethC netns client
sudo ip a add 192.168.0.1/24 dev vethR
sudo ip link set dev vethR up

echo "Done"


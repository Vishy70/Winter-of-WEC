#!/bin/bash

#sudo ip netns exec client /bin/bash
sudo ip link set dev lo up
sudo ip addr add 192.168.0.2/24 dev vethC
sudo ip link set dev vethC up
sudo ip route add default via 192.168.0.1
exit

echo "Done"
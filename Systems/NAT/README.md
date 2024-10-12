# Networking: Creating a NAT (Network Address Translator) !

This repositories contains my final submissions for the Networking tasks. Have a look at it!

(Note: This is my first time scripting in bash, so not all scripts are self-contained i.e. you may have to run several scripts/commands separately, or run couple of additional commands outside the script. Will try and improve it another time.)

# The Topology

|Client| <--------> |Router (NAT)| <--------> |Internet (Simulated Public Network)|

This simple diagram clearly shows what needs to be done. In order to setup the net topology, I did the following:
- Setup the client/lan using a **linux network namespaces** (One has been setup in the scripts).
- Keep the host (default network namespace) as the lan **edge router** -cum- **firewall**.
- Use the host's WI-FI interface (**wlp45s0**) as its connection to the internet.

# Connecting Client to Router via (V)Ethernet

After adding the client network-namespace using `sudo ip netns add client`, I did the following:
- Setup a virtual ethernet cable, and put one end of interface in the client (other is default in host/router).

- Set ip addresses for both interface of the veth, and _bring up_ the interface on both devices.

- Set default gateway on the _client_ as the _router_

To setup the topology, and run the scripts, do the following:
- Make sure you are in the `Winter-of-WEC/Systems/NAT` directory

- Ensure the scripts are excutable, by running `chmod +x <name-of-the-script>.sh` (do this for all the scripts)

- Open two terminal windows: one for **router**(host machine - do nothing), and one for **client**(setup will be done below...)

- In **router**, run `sudo ./set-netns-and-config-router.sh`. You should see done, finally.

- Now setup the **client** terminal by running: `sudo ip netns exec client /bin/bash`

- Inside **client** terminal, run `sudo ./veth-client-to-router.sh`. You should see done, finally.

- To test if the **client** and **router** are connected, run `ping 192.168.0.2` on the **router**, or `ping 192.168.0.1` on the **client**. ICMPs should successfully reach and return.
- However, `ping 1.1.1.1`, which is a public DNS operated by Cloudflare & APNIC, isn't reachable from **client**. We will enable this in the next step.
# Networking: Creating a NAT (Network Address Translator) !

This repositories contains my final submissions for the Networking tasks. Have a look at it!

(Note: This is my first time scripting in bash, so not all scripts are self-contained i.e. you may have to run several scripts/commands separately, or run couple of additional commands outside the script. Will try and improve it another time.)

# The Topology

|Client| <--------> |Router (NAT)| <--------> |Internet (Simulated Public Network)|

This simple diagram clearly shows what needs to be done. In order to setup the net topology, I did the following:
- Setup the client/lan using a **linux network namespaces** (One has been setup in the scripts)
- Keep the host (default network namespace) as the lan **edge router** -cum- **firewall**
- Use the host's WI-FI interface (**wlp45s0**) as its connection to the internet

# Connecting Client to Router via (V)Ethernet

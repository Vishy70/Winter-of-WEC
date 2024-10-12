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

# Masquerading

In order to enable the **client** to access the actual internet (right now, default gateway receives packet, and **router** just drops their packets), we need to enable forwarding on the host, and give it the policy to forward from this subnet. 

In addition, since the client would be an entire subnet and the internet interface is singular (for me, `wlp45s0`), we use **masquerading** to map private ip address at this router (thus, becomes a firewall!). Thus: 

- Setup a `POSTROUTING` masquerade on the NAT table, for the subnet/**client**: 192.168.0.0/24.

- Allow forwarding in the Filter table, between veth and internet interface (wlp45s0).

To set up the masquerading, ensure and execute the following:

- Open the `masquerading.sh` script.

    - Replace all instances of `wlp45s0` with an internet interface on _your_ device.

    - You can find one of these interfaces using the command `ip a`; the list shows the eligible names (search for what they mean :D )
- In the **router** terminal, execute `sudo ./masquerading.sh`. You should see done, finally.

- To test if the setup has succeeded, execute in the **client** terminal: `ping 1.1.1.1`. You should see that the ICMPs would have successfully reached and returned.

# Port Forwarding
One of the bonus tasks mentioned was to configure a setup so that hosts from the internet could communicate with our **clientt**, as if it was a web server. The current masquerading setup doesn't expose the subnet (which is good), nor does it handle redirecting any externel connections to the **client**. To fix this, I use the concept of **port forwarding**. In addition, we setup a simple 


- We use port forwarding to pre-route tcp connections on port 80 of the **router** to go to destination of the **client** (now, the new server) - 192.168.0.2:161 .

- Ensure that the various tcp connection types are forwarded properly.

To setup port-forwarding, ensure and execute the following:

- Open the `port-forwarding.sh` script.

    - Replace all instances of `wlp45s0` with an internet interface on _your_ device.

    - You can find one of these interfaces using the command `ip a`; the list shows the eligible names (search for what they mean :D )

- In the **router** terminal, execute `sudo ./port-forwarding.sh`. You should see done, finally.

- To test if the setup has succeeded, execute in the **client** terminal: `server.py` (you may need to run with root privilege...). You will see the following output:

- To test if you can access the **client** server: 
    
    - Find out the **IP ADDRESS** of the **router** interface that you are using (for me, 192.168.29.156 and wlp45s0).

    - Find out that of another device that connects to the same network as the interface (wlp45s0) connects to.

    - On that device, in a new `bash terminal`, execute: `curl http://<IP-of-router>:80/` (for me, `curl http://192.168.29.156:80/`).


    - You should receive a response that says "Hello from Flask, on Vishy's machine!"

# Restrict traffic

As the other bonus task, we had to restrict **outbound** traffic to allow only HTTP and HTTPs connections. I wasn't able to get it to work properly however, but here is my approach:

- Enable http(s) outbound connections using the Filter table, Forward since we are doing this from the router and want to configure for our **client**.

- Restrict all other connections (below the above in the table)

To set this final task up:
- Open the `outbound-restricter.sh` script.

    - Replace all instances of `wlp45s0` with an internet interface on _your_ device.

    - You can find one of these interfaces using the command `ip a`; the list shows the eligible names (search for what they mean :D )

- Run the following script in the **router** terminal: `sudo ./out-bound-restricter.sh`. You should see a done, finally.

- If successful, the following command should be fine: `curl http://google.com`. But the following shouldn't: `ping 1.1.1.1`. But, doesn't seem like the script has done exactly what I wanted... 

I think those are all of the tasks attempted! :D

# Challenges faced

# Basic-Firewall
Linux Firewall using iptables with basic rules

Designed  a firewall for Linux that will implement the following rules:

* Set the default policies to DROP.
* Create a set of rules that will:
  Permit inbound/outbound ssh packets.
  Permit inbound/outbound www packets.
  Drop inbound traffic to port 80 (http) from source ports less than 1024.
  Drop all incoming packets from reserved port 0 as well as outbound traffic to port 0.
  Create a set of user-defined chains that will implement accounting rules to keep track of
www, ssh traffic, versus the rest of the traffic on your system.

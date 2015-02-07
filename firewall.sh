##!/bin/sh

IPT="/sbin/iptables"
 
clear
# Flushing all rules
$IPT -F
$IPT -X
 
# DROP all incomming traffic
 
$IPT -P INPUT DROP
$IPT -P FORWARD DROP
$IPT -P OUTPUT DROP

# CHAINS
$IPT -N otherAccept
$IPT -N otherDrop
$IPT -N wwwIn
$IPT -N wwwOut
$IPT -N sshIn
$IPT -N sshOut 

$IPT -A otherAccept -j ACCEPT
$IPT -A otherDrop -j DROP
$IPT -A wwwIn -j ACCEPT
$IPT -A wwwOut -j ACCEPT
$IPT -A sshIn -j ACCEPT
$IPT -A sshOut -j ACCEPT

# Drop inbound traffic to port 80 / 443 from source ports less than 1024

$IPT -A INPUT  -p tcp  --dport 80   --sport 0:1023 -j otherDrop
$IPT -A INPUT -p tcp  --dport 443   --sport 0:1023 -j otherDrop
 
# Allow DNS
$IPT -A OUTPUT -p UDP --dport 53 -j otherAccept
$IPT -A INPUT -p UDP --sport 53 -j otherAccept
$IPT -A OUTPUT -p TCP --dport 53 -j otherAccept
$IPT -A INPUT -p TCP --sport 53 -j otherAccept
 
# Allow DHCP
$IPT -A OUTPUT -p UDP --dport 68 -j otherAccept
$IPT -A INPUT -p UDP --sport 68 -j  otherAccept
$IPT -A OUTPUT -p TCP --dport 68 -j otherAccept
$IPT -A INPUT -p TCP --sport 68 -j  otherAccept

#DROP OUTBOUND destination port 0

$IPT -A OUTPUT -p UDP --dport 0 -j otherDrop
$IPT -A OUTPUT -p TCP --dport 0 -j otherDrop

# DROP INBOUND source port 0

$IPT -A INPUT -p UDP --sport 0 -j otherDrop
$IPT -A INPUT -p TCP --sport 0 -j otherDrop

 
# Allow Inbound / Outbound SSH   

$IPT -A INPUT -p tcp --dport 22 -j sshIn
$IPT -A INPUT -p tcp --sport 22 -j sshIn

$IPT -A OUTPUT -p tcp --sport 22 -j sshOut
$IPT -A OUTPUT -p tcp --dport 22 -j sshOut

# Allow Inbound / Outbound www

$IPT -A INPUT  -p tcp --sport 80 -j wwwIn
$IPT -A OUTPUT -p tcp --dport 80 -j wwwOut
$IPT -A INPUT  -p tcp --dport 80 -j wwwIn
$IPT -A OUTPUT -p tcp --sport 80 -j wwwOut

$IPT -A OUTPUT -p tcp --dport 443 -j wwwOut
$IPT -A INPUT  -p tcp --sport 443 -j wwwIn
$IPT -A OUTPUT -p tcp --sport 443 -j wwwOut
$IPT -A INPUT  -p tcp --dport 443 -j wwwIn

# save, restart, and check the iptables

service iptables save
service iptables restart
iptables -L -n -v -x
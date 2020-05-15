#!/bin/bash
# Setting Bonding in Rock Nodes
# S Jena
# May 2 IST 2017
for i in {2..9}
do
export MYHOST="compute-0-"${i}
export MYIP="192.168.1.10"${i}

rocks list host interface $MYHOST
echo "rocks add host bonded $MYHOST channel=bond0 interfaces=eth0,eth1 ip=$MYIP network=private"
rocks add host bonded $MYHOST channel=bond0 interfaces=eth0,eth1 ip=$MYIP network=private
rocks list host interface $MYHOST

echo "rocks set host interface options $MYHOST bond0 options=\"miimon=100 mode=balance-rr\""
rocks set host interface options $MYHOST bond0 options="miimon=100 mode=balance-rr"
rocks list host interface $MYHOST

ssh $MYHOST rocks list host interface localhost

echo "rocks sync config"
rocks sync config
ssh $MYHOST rocks list host interface localhost

echo "rocks sync host network $MYHOST"
rocks sync host network $MYHOST


rocks list host interface $MYHOST
ssh $MYHOST rocks list host interface localhost



echo "----------------------------------------------------"

done


#!/bin/bash
# Manual Shutdown each node
# S Jena
# Fri Dec 15 13:44:21 IST 2016
for i in {0..19}
do
   echo "----------------------------------------"
   echo "Shuting Down CN.0.$i times"
   ssh compute-0-${i} init 0
done

#ssh usernode init 0


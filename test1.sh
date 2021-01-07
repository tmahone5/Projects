#!/bin/bash
#filename='OS.txt'
n=1
while read line;
do
	# for read each line
	echo " $n : $line"
	n=$((n+1))
done

#!/bin/bash

echo "list all the name"
read name

while $name -ne done
do	
	   aws s3 rb s3://$name --force
   done

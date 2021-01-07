#!/bin/bash
# Bash script to automate deleting s3 buckets

#clear screen
clear 

# command to list buckets
sudo aws s3 ls

# message to user
echo "What bucket would you like to delete?"


# read command allows user input 
read bucket bucket2

# variable for buckets
mybuckets="$bucket $bucket2"


# for loop 
for x in $mybuckets
do
	aws s3 rb s3://$x --force
done

# list of buckets after delete
sudo aws s3 ls

# Messages for User
echo YOUR BUCKET HAS BEEN DELETED
echo Do you have more buckets to delte?

# read command for user input
read finish 

# if statement 
if [ $finish = "yes" ]
then
    ./awsrb.sh
else
    echo "Goodbye!"	
fi



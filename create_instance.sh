#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
INSTANCE_TYPE=""
IMAGE_ID=ami-0b4f379183e5706b9
SECURITY_GROUP_ID=sg-0de06c7e419c50b0c



for i in "${NAMES[@]}"
do 
   if [ "$i" == "mongodb" ] || [ "$i" == "mysql" ];
   then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
   echo "Creating $i instance"
   aws ec2 run-instances \
        --image-id "$IMAGE_ID" \
        --instance-type "$INSTANCE_TYPE" \
        --security-groups "$SECURITY_GROUP_ID" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]"
done

#Tag the instance
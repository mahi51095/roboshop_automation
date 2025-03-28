#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
INSTANCE_TYPE=""
IMAGE_ID=ami-0b4f379183e5706b9
SECURITY_GROUP_ID=sg-0de06c7e419c50b0c



for i in "${NAMES[@]}";
do 
   if [ "$i" == "mongodb" ] || [ "$i" == "mysql" ];
   then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
   
   IP_ADDRESS=$(aws ec2 run-instances \
        --image-id "$IMAGE_ID" \
        --instance-type "$INSTANCE_TYPE" \
        --security-group-ids "$SECURITY_GROUP_ID" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "Creating $i instance : $IP_ADDRESS"

    #aws route53 change-resource-record-sets --hosted-zone-id ZXXXXXXXXXXXXXX \
#--change-batch '{
 # "Changes": [{
 #   "Action": "CREATE",
 #   "ResourceRecordSet": {
  #    "Name": "example.com",
 #     "Type": "A",
  #    "TTL": 300,
  #    "ResourceRecords": [{ "Value": "192.168.1.10" }]
 #   }
 # }]
#}'

done

#Tag the instance
#Add route 53 record

#Improvemnt
#Check already created instance or not
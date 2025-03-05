#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/home/centos/roboshop_automation
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ]
then
    echo -e  "$R ERROR : Please run script with root access. $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "Installing $2 .... $R FAILURE $N"
        exit 1
    else
        echo -e "Installing $2 .... $G SUCCESS $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied Mongodb repo into yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installation of Mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling Mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Edited Mongodb Config"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "restarting Mongodb"


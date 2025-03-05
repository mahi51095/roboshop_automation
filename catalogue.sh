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
        echo -e "$2 .... $R FAILURE $N"
        
    else
        echo -e "$2 .... $G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Setting up NPM Source."

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing Nodejs"

#Once the user is created, if you run script for 2nd time
#This command will fail
#Improvement: First check the user alredy exists or not, If not exists create one.

useradd roboshop &>>$LOGFILE

#Write a condition weather diretory already exists or not
mkdir /app &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "Downlaoding catologue zip file"

cd /app &>>$LOGFILE

unzip /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "Extracting catologue zip file"

cd /app &>>$LOGFILE

npm install &>>$LOGFILE

VALIDATE $? "Installing NPM "

cp /home/centos/roboshop_automation/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "Copying catalogue service "

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "Enabling catalogue"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "Starting catalogue"

cp /home/centos/roboshop_automation/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copying mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Installing mongodb-org-shell"

mongo --host mongodb.joindevops.sbs </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "Loading Schema"

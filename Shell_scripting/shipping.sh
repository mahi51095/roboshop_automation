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

yum install maven -y &>>$LOGFILE

VALIDATE $? "Installing Maven "

useradd roboshop &>>$LOGFILE

VALIDATE $? "Used addition"

mkdir /app &>>$LOGFILE

VALIDATE $? "Creating /app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "Downloading shiiping.zip artifactory"

cd /app &>>$LOGFILE

VALIDATE $? "Moving to app directory"

unzip /tmp/shipping.zip &>>$LOGFILE

VALIDATE $? "Unzipping shipping.zip"

cd /app &>>$LOGFILE

VALIDATE $? "Changing directory"

mvn clean package &>>$LOGFILE

VALIDATE $? "Cleaning of maven pkg"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE

VALIDATE $? "moving of shipping jar"

cp /home/centos/roboshop_automation/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

VALIDATE $? "copying of shipping service."

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Reloading of daemon"

systemctl enable shipping &>>$LOGFILE

VALIDATE $? "Enabling shipping"

systemctl start shipping &>>$LOGFILE

VALIDATE $? "Starting Shipping"

yum install mysql -y &>>$LOGFILE

VALIDATE $? "Installing mysql"

mysql -h mysql.joindevops.sbs -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE

VALIDATE $? "Loading of schema"

systemctl restart shipping &>>$LOGFILE

VALIDATE $? "Restarting of schema "
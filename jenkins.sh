USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "Please enter DB password:"
read -s mysql_root_password
VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi


cp /home/ec2-user/Jenkins-install/jenkins.repo /etc/yum.repos.d/jenkins.repo &>>$LOGFILE
VALIDATE $? "Copied backend service"

rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key &>>$LOGFILE
VALIDATE $? "jenkin key imported"

yum install fontconfig java-17-openjdk -y &>>$LOGFILE
VALIDATE $? "Installing java"

yum install jenkins -y y &>>$LOGFILE
VALIDATE $? "Installing jenkins"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon-reload "


systemctl enable jenkins &>>$LOGFILE
VALIDATE $? "Enabling jenkins Server"

systemctl  start jenkins &>>$LOGFILE
VALIDATE $? "Enabling jenkins Server"
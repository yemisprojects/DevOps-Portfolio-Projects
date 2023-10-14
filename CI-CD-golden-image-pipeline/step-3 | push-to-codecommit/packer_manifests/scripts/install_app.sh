#! /bin/bash -x

#JAVA-APP install
sudo amazon-linux-extras enable java-openjdk11
yum clean metadata && sudo yum -y install java-11-openjdk
mkdir /home/ec2-user/app

#install mysql client for troubleshooting connection to RDS
sudo rpm -e --nodeps mariadb-libs-*
sudo amazon-linux-extras enable mariadb10.5 && sudo yum install -y mariadb
mysql -V
sudo yum install -y telnet

#Userdata troubleshooting:
# /var/lib/cloud/instances/[instance-id]/user-data.txt or #/var/log/cloud-init-output.log

#!/bin/bash

# To connect to your EC2 instance and install the Apache web server with PHP

yum update -y &&
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2 &&
yum install -y httpd &&
systemctl enable httpd.service
systemctl start httpd
cd /var/www/html
wget  https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-ARCHIT/v7.2.0.prod-c9fa6dab/lab-2-VPC/scripts/instanceData.zip
unzip instanceData.zip

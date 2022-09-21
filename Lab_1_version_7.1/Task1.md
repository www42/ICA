# Lab 1 (Content Version 7.1.10)

## Task 1 Create an Amazon EC2 Instance using the AWS Management Console

### Task 1.10 Configure user data

#### 23.

```bash
#!/bin/bash -ex
sudo yum update -y
sudo yum install -y httpd php
sudo service httpd start
sudo systemctl enable httpd.service
cd /var/www/html
wget https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-ARCHIT/v7.1.10.prod-bfa9129b/lab-1-EC2/scripts/instanceAdata.zip
unzip instanceAdata.zip

```
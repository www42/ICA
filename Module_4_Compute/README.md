* Lab VPC two public subnets in two different Availability Zones
* Protect against accidental deletion
* Advanced details -> User data (as text)

```bash
#!/bin/bash
yum -y install httpd
systemctl enable httpd
systemctl start httpd
echo '<html><h1>Hello From Your Web Server!</h1></html>' > /var/www/html/index.html  
```

* Tags  Name: Web Server
* Security group Delete ssh rule
* Launch without ssh key

* Status check
* Actions --> Monitor and troubleshoot --> Get system log

* Security group: Add inbound rule port 80

## Lab Guide 7.1.8

### InstanceA

```bash
#!/bin/bash -ex
sudo yum update -y
sudo yum install -y httpd php
sudo service httpd start
sudo systemctl enable httpd.service
cd /var/www/html
wget https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-ARCHIT/v7.1.8/lab-1-EC2/scripts/instanceAdata.zip
unzip instanceAdata.zip
```

download zip file 
```bash
curl -0 https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-ARCHIT/v7.1.8/lab-1-EC2/scripts/instanceAdata.zip --output instanceAdata.zip
mkdir html
cd html
unzip ../instanceAdata.zip
```

### InstanceB

```bash

```
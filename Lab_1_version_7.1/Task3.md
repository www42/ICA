# Lab 1 (Content Version 7.1.10)

## Task 3 Create an Amazon EC2 instance using the CloudFormation service

`Task3.yaml`

```yaml
AWSTemplateFormatVersion: 2010-09-09

Description: Lab 1 Task3 CloudFormation template which adds one additional Amazon EC2 instance to the existing VPC.

Parameters:

  AmazonLinuxAMIID:
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2

Resources:

###########
# EC2 instance creation and installs a simple web application
###########

  InstanceC:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: !Ref AmazonLinuxAMIID
      InstanceType: 't3.micro'
      SubnetId: !ImportValue LabPublicSubnetID
      SecurityGroupIds:
        - !ImportValue LabInstanceSecurityGroupID
      UserData: !Base64 |
        #!/bin/bash -ex
        sudo yum update -y
        sudo yum install -y httpd php
        sudo service httpd start
        sudo systemctl enable httpd.service
        cd /var/www/html
        wget https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-ARCHIT/v7.1.8/lab-1-EC2/scripts/instanceCdata.zip
        unzip instanceCdata.zip
      Tags:
        - Key: Name
          Value: InstanceC

Outputs:

  InstanceCPublicDNS:
    Description: 'Public DNS value for InstanceC'
    Value: !GetAtt InstanceC.PublicDnsName
```
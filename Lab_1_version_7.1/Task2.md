# Lab 1 (Content Version 7.1.10)

## Task 2 Create an Amazon EC2 instance using the AWS Command Line Interface

### Task 2.2 Obtain the AMI to use

#### 40.

```bash
# Set the Region
AZ=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
export AWS_DEFAULT_REGION=${AZ::-1}

# Obtain latest Linux AMI
AMI=$(\
    aws ssm get-parameters \
        --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
        --query 'Parameters[0].[Value]' \
        --output text
)
echo $AMI
```

### Task 2.3 Obtain the subnet to use

#### 41.

```bash
SUBNET=$(\
    aws ec2 describe-subnets \
        --filters 'Name=tag:Name,Values=LabPublicSubnet' \
        --query Subnets[].SubnetId \
        --output text
)
echo $SUBNET
```

### Task 2.4 Obtain the Security Group to use

#### 42.

```bash
SG=$(\
    aws ec2 describe-security-groups \
        --filters 'Name=tag:Name,Values=LabInstanceSecurityGroup' \
        --query SecurityGroups[].GroupId \
        --output text
)
echo $SG
```

### Task 2.5 Download a user data script

#### 43.

```bash
cd ~
wget https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-ARCHIT/v7.1.8/lab-1-EC2/scripts/UserDataInstanceB.txt
```

### 44.

```bash
cat UserDataInstanceB.txt
```

### Task 2.6 Launch the instance

#### 45.

```bash
INSTANCE=$(\
    aws ec2 run-instances \
        --image-id $AMI \
        --subnet-id $SUBNET \
        --security-group-ids $SG \
        --user-data file://./UserDataInstanceB.txt \
        --instance-type t3.micro \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=InstanceB}]' \
        --query 'Instances[*].InstanceId' \
        --output text \
)
```

#### 46.

```bash
echo $INSTANCE
```

### Task 2.7 Wait for the instance to be ready

#### 47.

```bash
aws ec2 describe-instances --instance-ids $INSTANCE
```

#### 49.
```bash
aws ec2 describe-instances \
    --instance-ids $INSTANCE \
    --query 'Reservations[].Instances[].State.Name' \
    --output text
```

### Task 2.8 Test connectivity to the new web server

#### 50.
```bash
aws ec2 describe-instances \
    --instance-ids $INSTANCE \
    --query 'Reservations[].Instances[].PublicDnsName' \
    --output text
```
# Task 2: Create an Amazon EC2 instance using the AWS Command Line Interface

## Task 2.1

## Task 2.2

### 41.

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

## Task 2.3

### 42.

```bash
SUBNET=$(\
    aws ec2 describe-subnets \
        --filters 'Name=tag:Name,Values=LabPublicSubnet' \
        --query Subnets[].SubnetId \
        --output text
)
echo $SUBNET
```

## Task 2.4

### 43.

```bash
SG=$(\
    aws ec2 describe-security-groups \
        --filters 'Name=tag:Name,Values=LabInstanceSecurityGroup' \
        --query SecurityGroups[].GroupId \
        --output text
)
echo $SG
```

## Task 2.5

### 44.

```bash
cd ~
curl -O https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-ARCHIT/v7.1.8/lab-1-EC2/scripts/UserDataInstanceB.txt
```

### 45.

```bash
cat UserDataInstanceB.txt
```

## Task 2.6

### 46.

```bash
INSTANCE=$(\
    aws ec2 run-instances \
        --image-id $AMI \
        --subnet-id $SUBNET \
        --security-group-ids $SG \
        --user-data file://./UserDataInstanceB.txt \
        --instance-type t3.micro \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=InstanceB}]' \
        --query 'Instances[*].InstanceId'
        --output text \
)
```

### 47.

```bash
echo $INSTANCE
```

## Task 2.7

### 48.

```bash
aws ec2 describe-instances --instance-ids $INSTANCE
```

### 50.
```bash
aws ec2 describe-instances \
    --instance-ids $INSTANCE \
    --query 'Reservations[].Instances[].State.Name' \
    --output text
```

## Task 2.8

### 51.
```bash
aws ec2 describe-instances \
    --instance-ids $INSTANCE \
    --query 'Reservations[].Instances[].PublicDnsName' \
    --output text
```
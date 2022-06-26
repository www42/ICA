# Task 2: Create an Amazon EC2 instance using the AWS Command Line Interface

# Set the Region
export AWS_DEFAULT_REGION='eu-central-1'

# Obtain latest Linux AMI
aws ec2 describe-images \
--owners amazon \
--filters "Name=name,Values=amzn2-ami-hvm-2.0.????????.?-x86_64-gp2" "Name=state,Values=available" \
--query "reverse(sort_by(Images, &Name))[:1].ImageId" \
--region sa-east-1 \
--output text


reverse(sort_by([*], &creationDate))[:1].{imageId:imageId}

# There are many Amazon AMIs (> 10'000)
aws ec2 describe-images \
    --owners amazon \
    --query 'length(Images)'

# In console's AMI catalog you can find AMIs marked as *Free tier eligible*.

aws ec2 describe-images --filters "Name=root-device-type,Values=ebs" "Name=architecture,Values=x86_64" --query 'Images[?BlockDeviceMappings[0].Ebs.VolumeSize<=`10`]'


<img src="../img/AMI_Catalog.png" alt="AMI Catalog" width="600"/>

```bash
aws ec2 describe-images \
    --owners amazon \
    --filters 'Name=image-id',Values=ami-09439f09c55136ecf
```

*Free tier eligible* is a combination of AMI and EC2 instance type. Often t2.micros is *Free tier eligible*. 

<img src="../img/Create_Instance.png" alt="Create Instance" width="600"/>

There is no easy way to get all *Free tier eligible* AMIs. 


```bash
aws ec2 describe-images \
    --owners amazon \
    --filters 'Name=name,Values=amzn2-ami-hvm-2.0.????????.?-x86_64-gp2' 'Name=state,Values=available' \
    --query 'sort_by(Images, &ImageId)[].{Name:Name,ImageId:ImageId}' --output text

```
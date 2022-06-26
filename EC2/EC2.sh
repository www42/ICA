aws ec2 describe-instances
aws ec2 describe-instances --query 'length(Reservations)'
aws ec2 describe-instances --query 'Reservations[*].Instances[0].InstanceId'
aws ec2 describe-instances --query 'Reservations[*].{InstanceId:Instances[0].InstanceId,State:Instances[0].State.Name,VpcId:Instances[0].VpcId,PrivateIpAddress:Instances[0].PrivateIpAddress}' --output table


# Set region
export AWS_DEFAULT_REGION='eu-central-1'

# Get image-id from console - no way found to automate
AMI='ami-0a1ee2fb28fe05df3'
aws ec2 describe-images --image-ids $AMI

# Get VPCs
aws ec2 describe-vpcs --query "Vpcs[*]" 
aws ec2 describe-vpcs --query "length(Vpcs)" 
aws ec2 describe-vpcs --query "Vpcs[*].{VpcId:VpcId,CidrBlock:CidrBlockAssociationSet[0].CidrBlock,IsDefault:IsDefault}" --output table 
aws ec2 describe-vpcs --query "Vpcs[?VpcId=='vpc-06d750ebcced0f623']"
# Get default VPC
#     by query
aws ec2 describe-vpcs --query 'Vpcs[?IsDefault==`true`]'
#     by filter
aws ec2 describe-vpcs --filters "Name=is-default,Values=true"

# Get subnet
aws ec2 describe-subnets --query 'Subnets[*].{VpcId:VpcId,SubnetId:SubnetId,CidrBlock:CidrBlock,AvailabilityZone:AvailabilityZone}' --output table

# avail zone C
SUBNET='subnet-01bfff4e8816aba32'

# Security group
SG='sg-0b141bd73b519f63d'

# SSH Key
aws ec2 describe-key-pairs --query 'KeyPairs[].{Name: KeyName, Type: KeyType, Fingerprint: KeyFingerprint}' --output table
KEY='MyKeyPair1'

# Run instance
INSTANCE=$(\
    aws ec2 run-instances \
        --image-id $AMI \
        --subnet-id $SUBNET \
        --security-group-ids $SG \
        --key-name $KEY \
        --user-data file://./UserDataInstanceB.txt \
        --instance-type t2.micro \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=InstanceB}]' \
        --query 'Instances[*].InstanceId' \
        --output text \
)

# SSH
ls -l $KEY.pem
ssh -i ec2-user@ec2-3-72-112-84.eu-central-1.compute.amazonaws.com
netstat -ant
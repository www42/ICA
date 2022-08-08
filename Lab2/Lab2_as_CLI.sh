# Architecting on AWS - Lab 2 - Build your Amazon VPC infrastructure
# ==================================================================

# --- Additional SSH: This is additional, original Lab has no SSH access
#                     In order to access the instances by SSH instead of Session Manager
#                  
# --- TODO: Session Manager (Quick config?)

# The region is given by CLI profile. 
aws configure list

# Task 1: Create an Amazon VPC in a region
# ----------------------------------------
cidr='10.0.0.0/16'
nameTag='LabVpc'
vpcId=$(aws ec2 create-vpc --cidr-block $cidr --tag-specification ResourceType=vpc,Tags="[{Key=Name,Value='$nameTag'}]" --query "Vpc.VpcId" --output text)
aws ec2 modify-vpc-attribute --enable-dns-hostnames --vpc-id $vpcId

# Task 2: Create Public and Private Subnets
# -----------------------------------------
availZoneA=$(aws ec2 describe-availability-zones --query "AvailabilityZones[0].ZoneName" --output text)
availZoneB=$(aws ec2 describe-availability-zones --query "AvailabilityZones[1].ZoneName" --output text)
availZoneC=$(aws ec2 describe-availability-zones --query "AvailabilityZones[2].ZoneName" --output text)

# public subnet
cidr='10.0.0.0/24'
availZone=$availZoneA
nameTag='Public Subnet'
publicSubnetId=$(aws ec2 create-subnet --vpc-id $vpcId  --cidr-block $cidr --availability-zone $availZone --tag-specification ResourceType=subnet,Tags="[{Key=Name,Value='$nameTag'}]" --query "Subnet.SubnetId" --output text)
aws ec2 modify-subnet-attribute --map-public-ip-on-launch --subnet-id $publicSubnetId

# private subnet
cidr='10.0.2.0/23'
availZone=$availZoneA
nameTag='Private Subnet'
privateSubnetId=$(aws ec2 create-subnet --vpc-id $vpcId  --cidr-block $cidr --availability-zone $availZone --tag-specification ResourceType=subnet,Tags="[{Key=Name,Value='$nameTag'}]" --query "Subnet.SubnetId" --output text)

# Task 3: Create an Internet gateway
# ----------------------------------
nameTag='Lab IGW'
igwId=$(aws ec2 create-internet-gateway --tag-specification ResourceType=internet-gateway,Tags="[{Key=Name,Value='$nameTag'}]" --query "InternetGateway.InternetGatewayId" --output text)
aws ec2 attach-internet-gateway --internet-gateway-id $igwId --vpc-id $vpcId

# Task 4: Route internet traffic in the public subnet to the internet gateway
# ---------------------------------------------------------------------------
nameTag='Public Route Table'
publicRouteTableId=$(aws ec2 create-route-table --vpc-id $vpcId --tag-specification ResourceType=route-table,Tags="[{Key=Name,Value='$nameTag'}]" --query "RouteTable.RouteTableId" --output text)
cidr='0.0.0.0/0'
aws ec2 create-route --destination-cidr-block $cidr --gateway-id $igwId --route-table-id $publicRouteTableId
publicRouteTableAssociationId=$(aws ec2 associate-route-table --route-table-id $publicRouteTableId --subnet-id $publicSubnetId --query "AssociationId" --output text)

# Task 5: Create a public security group
# --------------------------------------
name='Public SG'
nameTag='Public SG'
description='Allows incoming traffic to public instance'
publicSecurityGroupId=$(aws ec2 create-security-group --group-name "$name" --description "$description" --vpc-id $vpcId --tag-specification ResourceType=security-group,Tags="[{Key=Name,Value='$nameTag'}]" --query "GroupId" --output text)
publicSecurityGroupRuleId=$(aws ec2 authorize-security-group-ingress --group-id $publicSecurityGroupId --protocol tcp --port 80 --cidr 0.0.0.0/0 --query "SecurityGroupRules[0].SecurityGroupRuleId" --output text)

# --- Additional SSH: Create security group to allow SSH
name='Allow SSH SG'
nameTag='Allow SSH SG'
description='Allows incoming SSH traffic to public instance'
myIp=$(curl -s http://checkip.amazonaws.com/)
sshSecurityGroupId=$(aws ec2 create-security-group --group-name "$name" --description "$description" --vpc-id $vpcId --tag-specification ResourceType=security-group,Tags="[{Key=Name,Value='$nameTag'}]" --query "GroupId" --output text)
sshSecurityGroupRuleId=$(aws ec2 authorize-security-group-ingress --group-id $sshSecurityGroupId --protocol tcp --port 22 --cidr "$myIp/32" --query "SecurityGroupRules[0].SecurityGroupRuleId" --output text)


# Task 6: Launch an Amazon EC2 instance into a public subnet
# ----------------------------------------------------------

# --- Additional SSH: Create key pair
keyName='myKeyPair'
keyFile="Lab2/$keyName.pem"
aws ec2 create-key-pair --key-name $keyName --key-type rsa --key-format pem --query "KeyMaterial" --output text > $keyFile && chmod 400 $keyFile

nameTag='Public Instance'
imageid='ami-0c956e207f9d113d5'
instanceType='t2.micro'   # free tier eligible, Lab states 't3.micro '
userData='file://./Lab2/UserDataLab2.sh'

# --- TODO:   --iam-instance-profile  Session Manager
publicInstanceId=$(aws ec2 run-instances --image-id $imageid --instance-type $instanceType --key-name $keyName --security-group-ids $publicSecurityGroupId --subnet-id $publicSubnetId --user-data $userData --associate-public-ip-address --tag-specification ResourceType=instance,Tags="[{Key=Name,Value='$nameTag'}]" --query "Instances[0].InstanceId" --output text)

# --- Additional SSH: Add security group to allow SSH
aws ec2 modify-instance-attribute --instance-id $publicInstanceId --groups $publicSecurityGroupId $sshSecurityGroupId


# Task 7: Connect to a public instance via HTTP
# ---------------------------------------------
publicDnsName=$(aws ec2 describe-instances --query "Reservations[?Instances[0].InstanceId=='$publicInstanceId'].Instances[0].PublicDnsName" --output text)
curl -s $publicDnsName | grep '<h2>'

# --- Additional SSH: Connect to instance via SSH
ssh -i $keyFile ec2-user@$publicDnsName
exit


# Task 8: Connect to the Amazon EC2 instance in the public subnet via Session Manager
# -----------------------------------------------------------------------------------

# --- TODO: aws ssm start-session --target $publicInstanceId


# Task 9: Create a NAT gateway and configure routing in the private subnet
# ------------------------------------------------------------------------
elasticIpAllocationId=$(aws ec2 allocate-address --query "AllocationId" --output text)
nameTag='Lab NGW'
natGatewayId=$(aws ec2 create-nat-gateway --subnet-id $publicSubnetId --allocation-id $elasticIpAllocationId --connectivity-type public --tag-specification ResourceType=natgateway,Tags="[{Key=Name,Value='$nameTag'}]" --query "NatGateway.NatGatewayId" --output text)
nameTag='Private Route Table'
privateRouteTableId=$(aws ec2 create-route-table --vpc-id $vpcId --tag-specification ResourceType=route-table,Tags="[{Key=Name,Value='$nameTag'}]" --query "RouteTable.RouteTableId" --output text)
cidr='0.0.0.0/0'
aws ec2 create-route --destination-cidr-block $cidr --nat-gateway-id $natGatewayId --route-table-id $privateRouteTableId
privateRouteTableAssociationId=$(aws ec2 associate-route-table --route-table-id $privateRouteTableId --subnet-id $privateSubnetId --query "AssociationId" --output text)

# Task 10: Create a security group for private resources
# ------------------------------------------------------
name='Private SG'
nameTag='Private SG'
description='Allows incoming traffic to private instance using public security group'
privateSecurityGroupId=$(aws ec2 create-security-group --group-name "$name" --description "$description" --vpc-id $vpcId --tag-specification ResourceType=security-group,Tags="[{Key=Name,Value='$nameTag'}]" --query "GroupId" --output text)
privateSecurityGroupRuleId=$(aws ec2 authorize-security-group-ingress --group-id $privateSecurityGroupId --protocol tcp --port 443 --source-group $publicSecurityGroupId --query "SecurityGroupRules[0].SecurityGroupRuleId" --output text)

# Task 11: Launch an Amazon EC2 instance into a private subnet
# ------------------------------------------------------------
nameTag='Private Instance'
imageid='ami-0c956e207f9d113d5'
instanceType='t2.micro'   # free tier eligible, Lab states 't3.micro '

# --- TODO:   --iam-instance-profile  Session Manager
privateInstanceId=$(aws ec2 run-instances --image-id $imageid --instance-type $instanceType --security-group-ids $privateSecurityGroupId --subnet-id $privateSubnetId --no-associate-public-ip-address --tag-specification ResourceType=instance,Tags="[{Key=Name,Value='$nameTag'}]" --query "Instances[0].InstanceId" --output text)

# Task 12: Connect to the Amazon EC2 instance in the private subnet
# -----------------------------------------------------------------

# --- TODO: aws ssm start-session --target $publicInstanceId


# Optional Task 1: Test connectivity to the private instance from the public instance
# -----------------------------------------------------------------------------------

# --- TODO: Session Manager Task 8 and Task 11


# Optional Task 2: Retrieve instance metadata
# -------------------------------------------
ssh -i $keyFile ec2-user@$publicDnsName
curl http://169.254.169.254/latest/meta-data/
curl http://169.254.169.254/latest/meta-data/public-hostname
exit






# List
# -----
aws ec2 describe-vpcs --query "Vpcs[*].{VpcId:VpcId,CidrBlock:CidrBlock,IsDefault:IsDefault,Tags:Tags[0].Value}" --output table
aws ec2 describe-subnets --filters "Name=vpc-id,Values='$vpcId'" --query "Subnets[*].{SubnetId:SubnetId,CidrBlock:CidrBlock,AvailabilityZone:AvailabilityZone,MapPublicIpOnLaunch:MapPublicIpOnLaunch,VpcId:VpcId,Tags:Tags[0].Value}" --output table
aws ec2 describe-internet-gateways --query "InternetGateways[*].{InternetGatewayId:InternetGatewayId,VpcId:Attachments[0].VpcId,Tags:Tags[0].Value}" --output table
aws ec2 describe-route-tables --query "RouteTables[*].{RouteTableId:RouteTableId,VpcId:VpcId,Main:Associations[0].Main,Tags:Tags[0].Value}" --output table
aws ec2 describe-security-groups --query "SecurityGroups[?VpcId=='$vpcId'].{GroupName:GroupName,GroupId:GroupId,VpcId:VpcId}" --output table
aws ec2 describe-security-group-rules --security-group-rule-ids $publicSecurityGroupRuleId
aws ec2 describe-security-group-rules --security-group-rule-ids $privateSecurityGroupRuleId
aws ec2 describe-security-group-rules --security-group-rule-ids $sshSecurityGroupRuleId
aws ec2 describe-key-pairs --query "KeyPairs[*].{KeyName:KeyName,KeyType:KeyType,KeyFingerprint:KeyFingerprint}" --output table
aws ec2 describe-instances --query "Reservations[*].Instances[0].{InstanceId:InstanceId,InstanceType:InstanceType,VpcId:VpcId,SubnetId:SubnetId,PrivateIpAddress:PrivateIpAddress,PublicIpAddress:PublicIpAddress,State:State.Name,Tag:Tags[0].Value}" --output table
aws ec2 describe-instances --query "Reservations[?Instances[0].InstanceId=='$publicInstanceId'].Instances[0].{InstanceId:InstanceId,InstanceType:InstanceType,VpcId:VpcId,SubnetId:SubnetId,PrivateIpAddress:PrivateIpAddress,PublicIpAddress:PublicIpAddress,State:State.Name,Tag:Tags[0].Value}" --output table
aws ec2 describe-addresses --query "Addresses[*].{PublicIp:PublicIp,AllocationId:AllocationId}" --output table
aws ec2 describe-nat-gateways --query "NatGateways[*].{NatGatewayId:NatGatewayId,State:State,SubnetId:SubnetId,Tag:Tags[0].Value}" --output table




# Lab Cleanup
# -----------
aws ec2 terminate-instances --instance-ids $privateInstanceId
aws ec2 terminate-instances --instance-ids $publicInstanceId

# Wait 3 minutes, then you can delete the Security Groups
aws ec2 delete-security-group --group-id $publicSecurityGroupId
aws ec2 delete-security-group --group-id $privateSecurityGroupId
aws ec2 delete-security-group --group-id $sshSecurityGroupId

aws ec2 disassociate-route-table --association-id $privateRouteTableAssociationId
aws ec2 delete-route-table --route-table-id $privateRouteTableId
aws ec2 delete-nat-gateway --nat-gateway-id $natGatewayId

aws ec2 release-address --allocation-id $elasticIpAllocationId

aws ec2 delete-key-pair --key-name $keyName && rm -f $keyFile
aws ec2 disassociate-route-table --association-id $publicRouteTableAssociationId
aws ec2 delete-route-table --route-table-id $publicRouteTableId
aws ec2 detach-internet-gateway --internet-gateway-id $igwId --vpc-id $vpcId
aws ec2 delete-internet-gateway --internet-gateway-id $igwId
aws ec2 delete-subnet --subnet-id $publicSubnetId
aws ec2 delete-subnet --subnet-id $privateSubnetId
aws ec2 delete-vpc --vpc-id $vpcId

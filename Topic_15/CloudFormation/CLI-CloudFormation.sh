# aws cli
aws --version
aws configure list-profiles
aws configure list

# describe-stacks (active stacks only, no deleted stacks)
aws cloudformation describe-stacks --query "length(Stacks)"
aws cloudformation describe-stacks --query "Stacks[*].{StackName:StackName,StackStatus:StackStatus}" --output table

# list-stacks (all stacks are listed)
# deleted stacks are visible for 90 days, you cannot delete deleted stacks
aws cloudformation list-stacks
aws cloudformation list-stacks --query "length(StackSummaries)"
aws cloudformation list-stacks --query "StackSummaries[*].{StackName:StackName,StackStatus:StackStatus}" --output table

# create-stack
stackName='s3Bucket-test1'
stackId=$(aws cloudformation create-stack --stack-name $stackName --template-body file://Module1/S3Bucket-CloudFormation.yaml --query "StackId" --output text)
stackName=$(aws cloudformation describe-stacks --query "Stacks[?StackId=='$stackId'].StackName" --output text)
aws cloudformation describe-stacks --stack-name $stackName

# Anmerkung: um einen stack zu erzeugen kann man kann auch sagen 
aws cloudformation deploy --template-file foo.yaml ----stack-name bar
# 'deploy' ist eigentlich dazu da, ein change set zu erzeugen. Wenn aber der gar nicht existiert wird er angelegt.

# describe-stack-resources
aws cloudformation describe-stack-resources --stack-name $stackName
aws cloudformation describe-stack-resources --stack-name $stackName --query "sort_by(StackResources[*].{LogicalResourceId:LogicalResourceId,ResourceType:ResourceType,ResourceStatus:ResourceStatus}, &ResourceType)" --output table

# delete-stack
aws cloudformation delete-stack --stack-name $stackName
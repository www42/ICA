
stackName='EC2-ica'

aws cloudformation describe-stacks --stack-name $stackName --query "Stacks[0].{StackName:StackName,StackStatus:StackStatus,StackDriftStatus:DriftInformation.StackDriftStatus}" --output table

aws cloudformation describe-stack-resources --stack-name $stackName --query "sort_by(StackResources[*].{LogicalResourceId:LogicalResourceId,ResourceType:ResourceType,ResourceStatus:ResourceStatus,StackResourceDriftStatus:DriftInformation.StackResourceDriftStatus}, &ResourceType)" --output table

aws cloudformation delete-stack --stack-name $stackName

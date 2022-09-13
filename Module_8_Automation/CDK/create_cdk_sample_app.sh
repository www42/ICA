# install cdk
npm install -g aws-cdk
cdk --version

# bootstrap
cdk bootstrap aws://<account number>/eu-central-1

# demo app typescript
mkdir cdk-demo-app
cd cdk-demo-app
cdk init app
cdk init app --language typescript
ls
cdk deploy


cdk destroy

cd ..
rm -rf cdk-demo-app

# demo app python
mkdir cdk_sample 
cd cdk_sample
cdk init sample-app --language python
source .venv/bin/activate
pip install -r requirements.txt

#       if 'import could not resolved Pylance'
#       command palette --> Python select interpreter --> enter path from 'which python' 
#       😃

# code cdk_sample/cdk_sample_stack.py

#     from distutils import core
#     from constructs import Construct
#     from aws_cdk import (
#         Duration,
#         RemovalPolicy,
#         Stack,
#         aws_s3 as s3,
#     )
#     
#     
#     class CdkSampleStack(Stack):
#     
#         def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
#             super().__init__(scope, construct_id, **kwargs)
#     
#             bucket = s3.Bucket(self, 'cdk-s3-static-website_s3-bucket',
#                 bucket_name= ('cdk-s3-static-website'),
#                 website_index_document= 'index.html',
#                 website_error_document= 'error.html',
#                 public_read_access= True,
#             )
#     





cdk ls
cdk synth
cdk deploy

aws cloudformation describe-stacks --query "Stacks[*].{StackName:StackName,StackStatus:StackStatus}" --output table
stackName='cdk-sample'
aws cloudformation describe-stacks --stack-name $stackName
aws cloudformation describe-stack-resources --stack-name $stackName --query "sort_by(StackResources[*].{LogicalResourceId:LogicalResourceId,ResourceType:ResourceType,ResourceStatus:ResourceStatus}, &ResourceType)" --output table


cdk destroy
deactivate
cd ..
rm -r cdk_sample
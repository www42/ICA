# https://aws.amazon.com/premiumsupport/knowledge-center/iam-assume-role-cli/
# Who am I in this aws cli session?
aws sts get-caller-identity

aws configure list-profiles


# Create new IAM user
# -------------------
# Create user
userName="Erwin.Schroedinger"
aws iam create-user --user-name $userName
aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId,Arn:Arn}' --output table

# User has no sign-in credentials (for console sign-in)
aws iam get-login-profile --user-name $userName

# User has no access keys (for AWS cli, SDKs, direct API calls)
aws iam list-access-keys --user-name $userName

# User has no policies (permissions) attached
aws iam list-attached-user-policies --user-name $userName

# Create policy. Will be attached to user.
aws iam create-policy --policy-name example-policy --policy-document file://example-policy.json
aws iam list-policies --query "Policies[?PolicyName=='example-policy'].{Arn:Arn,DefaultVersionId:DefaultVersionId}" --output table

# Delete policy
# policyArn=$(aws iam list-policies --query "Policies[?PolicyName=='example-policy'].Arn" --output text)
# aws iam delete-policy --policy-arn $policyArn

# Attach policy to user
policyArn=$(aws iam list-policies --query "Policies[?PolicyName=='example-policy'].Arn" --output text)
aws iam attach-user-policy --user-name $userName --policy-arn $policyArn
aws iam list-attached-user-policies --user-name $userName





# Delete IAM user
# ---------------
userName="albert.training"
# User has sign-in credentials -> delete login profile
aws iam get-login-profile --user-name $userName
aws iam delete-login-profile --user-name $userName

# User has policies (permissions) directly attached -> detach policies
aws iam list-attached-user-policies --user-name $userName
aws iam detach-user-policy --user-name $userName --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

# Delete user
aws iam delete-user --user-name $userName
aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId,Arn:Arn}' --output table
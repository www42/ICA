# Assume a role in an AWS cli session
# -----------------------------------

# https://aws.amazon.com/premiumsupport/knowledge-center/iam-assume-role-cli/

# IAM Users
aws iam list-users
aws iam list-users --query 'Users[].UserName'
aws iam list-users --query 'Users[].[UserName,UserId]'
aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId}'
aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId}' --output text
aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId}' --output table
aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId}' --output yaml

# IAM Groups
aws iam list-groups

# Policies
aws iam list-policies
aws iam list-policies --query 'length(Policies)'
aws iam list-policies --max-items 3
aws iam list-policies --query 'Policies[].PolicyName'
aws iam list-policies --query 'sort_by(Policies, &PolicyName)[].PolicyName'
aws iam list-policies --query "Policies[?PolicyName=='AmazonGlacierReadOnlyAccess']"
aws iam list-policies --query "Policies[?PolicyName=='IAMFullAccess']"
aws iam list-policies --query "Policies[?PolicyName=='IAMFullAccess'].{Arn:Arn,DefaultVersionId:DefaultVersionId}"
aws iam list-policies --query "Policies[?PolicyName=='AdministratorAccess'].{Arn:Arn,DefaultVersionId:DefaultVersionId}"

# There are many builtin policies. Two examples
aws iam get-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam get-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

aws iam get-policy-version --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --version-id v5
aws iam get-policy-version --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --version-id v1

# Roles
aws iam list-roles
aws iam list-roles --query 'Roles[].RoleName'
aws iam list-roles --query 'Roles[].{RoleName:RoleName,Arn:Arn}' --output table
aws iam list-roles --query 'Roles[].[RoleName,Arn]' --output table

aws iam get-role --role-name MyS3AdminRole

# List attached policies
aws iam list-attached-user-policies --user-name paul.training
aws iam list-attached-group-policies --group-name Administrators
aws iam list-attached-role-policies --role-name MyS3AdminRole

# Assume role
aws sts get-caller-identity
aws sts assume-role --role-arn "arn:aws:iam::502737081024:role/MyS3AdminRole" --role-session-name AWSCLI-Session

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""

aws sts get-caller-identity

unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
aws sts get-caller-identity
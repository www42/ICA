aws --version

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/index.html
aws iam list-users
aws iam list-users --query 'Users[].UserName'
aws iam list-users --query 'Users[].[UserName,UserId]'
aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId}'
aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId}' --output text
aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId}' --output table
aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId}' --output yaml

aws iam list-groups
aws iam list-roles
aws iam list-policies
aws iam list-policies --query 'length(Policies)'
aws iam list-policies --max-items 3
aws iam list-policies --query 'Policies[].PolicyName'
aws iam list-policies --query 'sort_by(Policies, &PolicyName)[].PolicyName'
aws iam list-policies --query "Policies[?PolicyName=='AmazonGlacierReadOnlyAccess']"
aws iam list-policies --query "Policies[?PolicyName=='IAMFullAccess']"
aws iam list-policies --query "Policies[?PolicyName=='IAMFullAccess'].{Arn:Arn,DefaultVersionId:DefaultVersionId}"
aws iam list-policies --query "Policies[?PolicyName=='AdministratorAccess'].{Arn:Arn,DefaultVersionId:DefaultVersionId}"

# Two built in policies
aws iam get-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam get-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

aws iam get-policy-version --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --version-id v5
aws iam get-policy-version --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --version-id v1
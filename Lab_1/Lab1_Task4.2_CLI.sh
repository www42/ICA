aws s3 ls

myCliBucket='labclibucket-69118'
aws s3 mb s3://$myCliBucket
aws s3 cp /home/ssm-user/HappyFace.jpg s3://$myCliBucket
aws s3 ls s3://$myCliBucket


aws s3 rm s3://$myCliBucket/HappyFace.jpg   # Access denied -not allowed in Lab environment
aws s3 rb s3://$myCliBucket --force         # Access denied -not allowed in Lab environment
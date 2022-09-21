aws s3 ls

myCliBucket='labclibucket-69118'
aws s3 mb s3://$myCliBucket
aws s3 cp /home/ssm-user/HappyFace.jpg s3://$myCliBucket
aws s3 ls s3://$myCliBucket

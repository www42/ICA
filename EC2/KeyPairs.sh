# -------------------
keyName='MyKeyPair2'
keyFile=$keyName.pem
# -------------------

# create-key-pair 
aws ec2 create-key-pair --key-name $keyName --key-type rsa --key-format pem --query 'KeyMaterial' --output text > $keyFile && chmod 400 $keyFile

# describe-key-pair
aws ec2 describe-key-pairs --key-name $keyName
ll $keyFile

aws ec2 describe-key-pairs
aws ec2 describe-key-pairs --output text
aws ec2 describe-key-pairs --query 'KeyPairs[].{Name: KeyName, Type: KeyType, Fingerprint: KeyFingerprint}' --output table
aws ec2 describe-key-pairs --query 'length(KeyPairs)'

# fingerprint
aws ec2 describe-key-pairs --key-name $keyName --query 'KeyPairs[].KeyFingerprint' --output text
openssl pkcs8 -in $keyFile -nocrypt -topk8 -outform DER | openssl sha1 -c


# delete-key-pair
aws ec2 delete-key-pair --key-name $keyName && rm -f $keyFile

# delete all key pairs
keys=$(aws ec2 describe-key-pairs --query 'KeyPairs[].KeyPairId' --output text)
for key in $keys
do
    aws ec2 delete-key-pair --key-pair-id $key
done


# connect to EC2 instance
ssh -i "testkey.pem" ec2-user@ec2-3-72-112-84.eu-central-1.compute.amazonaws.com
netstat -ant

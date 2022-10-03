aws sqs list-queues

queueName="foo-queue.fifo"
queueUrl=$(aws sqs create-queue --queue-name $queueName --attributes "FifoQueue=true,ContentBasedDeduplication=true" --query "QueueUrl" --output text)

aws sqs get-queue-attributes --queue-url $queueUrl --attribute-names All

aws sqs send-message --queue-url $queueUrl --message-body "Hello World!" --message-group-id "0000001"


aws sqs delete-queue --queue-url $queueUrl
# solution stacks
aws elasticbeanstalk list-available-solution-stacks
aws elasticbeanstalk list-available-solution-stacks --query "length(SolutionStackDetails)"
aws elasticbeanstalk list-available-solution-stacks --query "SolutionStackDetails[*].SolutionStackName"

# applications
aws elasticbeanstalk describe-applications
aws elasticbeanstalk describe-applications --query "Applications[*].ApplicationName" --output text
aws elasticbeanstalk delete-application --application-name "getting started app"

# environments
aws elasticbeanstalk describe-environments


# eb cli    https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html
eb --version
eb init

# List environments within the actual application
eb list --all

# Terminate (remove) environment - not application
eb terminate



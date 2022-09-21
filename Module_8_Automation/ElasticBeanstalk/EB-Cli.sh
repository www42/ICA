# solution stacks
aws elasticbeanstalk list-available-solution-stacks
aws elasticbeanstalk list-available-solution-stacks --query "length(SolutionStackDetails)"
aws elasticbeanstalk list-available-solution-stacks --query "SolutionStackDetails[*].SolutionStackName"

# applications
aws elasticbeanstalk describe-applications
# Build image
imageName='hello-ica'
cd $imageName
cat Dockerfile
docker build -t $imageName .
docker image ls

# Test image
docker run -d --name test -p 8080:80 $imageName
docker container ls --all
docker kill test
docker rm test

# Registry
# 'ecr' is private registry, public registry is 'ecr-public'.
# You can have only one private registry per aws account. That's why there is no 'ecr list-registries'.
aws ecr describe-registry
registryId=$(aws ecr describe-registry --query "registryId" --output text)

region='eu-central-1'
registry="$registryId.dkr.ecr.$region.amazonaws.com"

# Repositories
aws ecr describe-repositories
aws ecr describe-repositories --query "repositories[*].{repositoryName:repositoryName,registryId:registryId}" --output table

# Create repository
# Repository = image (each image [with version tags] lives in it's own repository)
repositoryName=$imageName
repositoryUri=$(aws ecr create-repository --repository-name $repositoryName --query "repository.repositoryUri" --output text)

# ECR login
aws ecr get-login-password | docker login --username AWS --password-stdin $registry

# Tag image for upload
docker tag hello-ica:latest $registry/$repositoryName
docker image ls

# Push image
docker push $registry/$repositoryName
aws ecr list-images --repository-name $repositoryName

# Pull image
docker pull $registry/$repositoryName


# Cleanup
# ---------
# Remove image from repository
aws ecr batch-delete-image --repository-name $repositoryName --image-ids imageTag=latest
aws ecr list-images --repository-name $repositoryName

# Remove repository
aws ecr delete-repository --repository-name $repositoryName
aws ecr describe-repositories --query "repositories[*].{repositoryName:repositoryName,registryId:registryId}" --output table

# Remove local image
docker image rm $registry/$repositoryName
docker image rm $imageName
docker image ls

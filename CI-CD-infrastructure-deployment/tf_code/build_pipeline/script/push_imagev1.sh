#!/usr/bin/env bash

if [[ $# -ne 3 ]] 
then
        echo "Example script usage"
        echo "$0 <ECR_REPO_URL> <AWS_CLI_PROFILE> <AWS_REGION>"
        exit 1
fi

ECR_REPO_URL=$1
AWS_CLI_PROFILE=$2
AWS_REGION=$3

docker pull yemisiomonijo/custom_codebuild:latest 
docker tag yemisiomonijo/custom_codebuild $ECR_REPO_URL 
aws ecr get-login-password --region $AWS_REGION --profile $AWS_CLI_PROFILE | docker login --username AWS --password-stdin $ECR_REPO_URL
docker push $ECR_REPO_URL 
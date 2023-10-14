<h2 align="center">Auto tag AWS solution deployed with Terraform</h2>

This repository is used for my [medium blog post](https://aws.plainenglish.io/how-to-auto-tag-new-aws-resources-and-deploy-solution-with-terraform-de48ec644d95)

<h2 align="center">AWS Autotag Achitecture</h2>

![Solution](https://github.com/yemisprojects/aws-autotag/blob/main/images/Architecture.png)
<h4 align="center"></h4>

<h2 align="center">Technical overview</h2>

This solution uses an automated workflow to tag newly created resources. When an AWS resource is created a corresponding event is logged by AWS Cloudtrail. This event will be captured by Eventbridge and trigger a rule set to monitor selected events. The triggered rule sends the event to a Lambda function to be processed. The Lambda function identifies the name of the IAM user or role that created the resource and tags the resource with the same name and any associated tags applied to the user or role.

## Pre-requisites
- Terraform CLI (1.0+) installed
- An AWS account and user account with admin permissions
- AWS CLI (2.0+) installed

## Deployment Steps

```bash
git clone https://github.com/yemisprojects/aws-autotag.git && cd aws-autotag
terraform init
terraform plan
terraform apply --auto-approve
```

## Blog Post

[![Image](https://github.com/yemisprojects/aws-autotag-private/blob/main/screenshots/blog_caption/Blog_post_AWS_resource_autotag.png "Tag New AWS Resources Automatically")](https://aws.plainenglish.io/how-to-auto-tag-new-aws-resources-and-deploy-solution-with-terraform-de48ec644d95)
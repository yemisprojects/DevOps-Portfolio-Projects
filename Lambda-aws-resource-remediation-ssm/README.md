<h2 align="center">Automate Remediation of Compliance with Systems Manager</h2>

This repository is used for my [medium blog post](https://medium.com/aws-in-plain-english/simplify-compliance-of-aws-resources-with-automated-remediation-workflows-85083f33a605)

<h2 align="center">Solution Architecture</h2>

![Solution](https://github.com/yemisprojects/aws-resource-compliance-ssm/blob/main/images/SolutionArchitecture.jpg)
<h4 align="center"></h4>

<h2 align="center">Technical overview</h2>

The solution consists of the following services; AWS Config, Lambda, EventBridge, System Manager Automation, SES, and SNS. After verifying no AWS Managed config rule caters to the requirements, we will create a custom config rule to track compliance. When a new resource is created or deleted or the configuration of any resource changes a Lambda function will be triggered to evaluate the compliance of the resource and it delivers the evaluation result back to the rule. Once, non-compliant resources are determined the System Manager Automation is triggered to remediate each resource. The automation workflow also includes an action to send notifications to a Cloud Administrator using SNS if any automation execution fails. After remediation, an event bridge rule will be triggered to invoke another Lamda function which will send a notification using Amazon SES to notify the resource owner about the remediated resource. The solution will be deployed using Terraform.

## Pre-requisites
- Terraform CLI (1.0+) installed
- An AWS account and user account with admin permissions
- AWS CLI (2.0+) installed

## Deployment Steps

To receive notifications, provide email address(es) to the variables in the terraform.tfvars file after cloning the repository. See an example below.

```
sender_email_address = "example@gmail.com"
sns_email_address = "example@gmail.com"
```

```bash
git clone https://github.com/yemisprojects/aws-resource-compliance-ssm.git
cd aws-resource-compliance-ssm && terraform init
terraform plan 
terraform apply --auto-approve 
```

## Blog Post

[![Image](https://github.com/yemisprojects/aws-resource-compliance-private/blob/main/blog_caption/systems_manager_compliance_blog_caption.png "Simplify Compliance of AWS resources with Automated Remediation Workflows")](https://medium.com/aws-in-plain-english/simplify-compliance-of-aws-resources-with-automated-remediation-workflows-85083f33a605)
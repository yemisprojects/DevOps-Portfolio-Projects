<h2 align="center">Build AWS Cross account Infrastructure Deployment Pipeline</h2>

![Solution](...png)
<h4 align="center"></h4>

<h2 align="center">Project Summary</h2>
By the end of the project, you will have accomplished the following:
👉 Created a fully managed AWS cross-account CI/CD pipeline
👉 Deployed a secure, highly available & scalable multi-tier web app
👉 Developed an ECR image for your pipeline
👉 Enforced vulnerability scanning and error detection in the pipeline 
👉 Emailed Infrastructure cost usage reports from your pipeline
👉 Received Slack notifications for the status of your pipeline 
👉 Setup email notifications for ASG scaling events and Cloudwatch alarms
👉 Generated reports for errors and vulnerabilities for the terraform code


.....Insert 3 tier webapp architecture

## Deployment Pre-requisites
- Knowledge of Terraform, AWS, Python, Docker, Shell scripting
- Docker, Infracost ( v0.10.29) and Terraform (1.6.1) installed (1.6.0 crashes)
- Two AWS accounts and an IAM user with admin permissions.
- AWS CLI (2.2+) installed and configured for both accounts
- Access to the project files on my GitHub repo
- Email address for pipeline notifications
- Registered domain name

## Deployment Steps
See my free [medium blog post](https://yemiodunade.medium.com/image-pipeline-with-packer-aws-codepipeline-and-aws-inspector-9e6e5dfafc83?sk=d3d30a80e3b72b02475451664023f352) for step by step guide

## Blog Post

[![Image](https://github.com/yemisprojects/golden-image-pipeline/blob/main/images/Published_post_snippet.png "Image pipeline with Packer, AWS CodePipeline, and AWS Inspector")](https://yemiodunade.medium.com/image-pipeline-with-packer-aws-codepipeline-and-aws-inspector-9e6e5dfafc83?sk=d3d30a80e3b72b02475451664023f352)

========================Pipeline add-ons=====================
Slack notifications
You will receive Slack notifications once the pipeline is triggered, and receive requests for manual approval or pipeline execution completes. A sample notification is shown below

Slack NotificationsTest reports 
Each CodeBuild project generates test reports. For example, the screenshot below shows a summary of the success rate of test cases for the security scans run by Checkov.

Checkov summary reportInfrastructure Cost reports
 Last but not least my favorite, the pipeline generates the snippet cost report shown below using Infracost. You can view the full report here

Infracost report
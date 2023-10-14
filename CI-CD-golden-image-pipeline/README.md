<h2 align="center">Image pipeline with Packer, AWS CodePipeline, and AWS Inspector</h2>

![Solution](https://github.com/yemisprojects/golden-image-pipeline/blob/main/images/draw_io_golden_ami_pipeline.png)
<h4 align="center"></h4>

<h2 align="center">Technical overview</h2>

The workflow for the image pipeline above is described below:

A git push to an AWS CodeCommit repository main branch generates an event that triggers an Eventbridge rule to start the pipeline. In the first build stage, a temp VPC is deployed using Terraform. Afterward, Packer spins up an EC2 instance in the VPC to create an AMI with an application installed. In the next phase, using Terraform an EC2 instance is created based on the new AMI with an AWS inspector agent installed.

Once the agent is healthy, AWS Inspector scans the instance for potential security issues against security standards such as the Center for Internet Security (CIS) Benchmarks and Common vulnerabilities and exposures (CVE) and if the system is configured according to security best practices. Once the assessment is completed a user is notified via SNS and the pipeline moves to a manual approval phase.

An assessment report with findings and recommendations from Inspector is sent in an email attachment using SES to a designated reviewer(s). After review, if there are no security issues a pipeline manual approval is given. In the final stage, the golden AMI is shared with other AWS accounts. The EC2 instance and VPC resources are destroyed and AWS Chatbot is used to send pipeline status notifications to a slack channel.

## Deployment Pre-requisites
- Basic knowledge of Terraform and AWS
- Terraform CLI (1.1+) installed
- AWS CLI (2.0+) installed and configured with access keys
- An AWS account and an IAM user with admin permissions.
- Another AWS account to verify a shared AMI

## Deployment Steps
See my free [medium blog post](https://yemiodunade.medium.com/image-pipeline-with-packer-aws-codepipeline-and-aws-inspector-9e6e5dfafc83?sk=d3d30a80e3b72b02475451664023f352) for step by step guide

## Blog Post

[![Image](https://github.com/yemisprojects/golden-image-pipeline/blob/main/images/Published_post_snippet.png "Image pipeline with Packer, AWS CodePipeline, and AWS Inspector")](https://yemiodunade.medium.com/image-pipeline-with-packer-aws-codepipeline-and-aws-inspector-9e6e5dfafc83?sk=d3d30a80e3b72b02475451664023f352)
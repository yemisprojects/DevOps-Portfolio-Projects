<h2 align="center">AWS Cross account Infrastructure Deployment Pipeline</h2>

![Pipeline Architecture](https://github.com/yemisprojects/DevOps-Portfolio-Projects/blob/main/cross-account-CI-CD-infrastructure/Images/Architecture.png)
<h4 align="center"></h4>

<h2 align="center">Project Summary</h2>
This project implements a cross account CI/CD infrastructure deployment pipeline. A tooling account will host the pipeline and the web app infrastructure will be deployed via the pipeline into a development account. Using a separate central tooling account creates an isolation from your workloads, allowing for granular IAM security controls improving the security of your AWS infrastructure. All resources will be deployed using Terraform.  To keep this AWS native, Codecommit will be used to store the terraform code for the workload account. A DevOps engineer triggers the pipeline after a merge to the main branch from a short-lived branch. 

The pipeline consists of 5 stages in addition to the source stage.
- Linting & security scan stage: TFLint is used to find possible terraform code errors and enforce best practices. There are a variety of IaC tools for static code analysis used to detect potential security and compliance violations. Only Checkov and Terrascan are used here for illustration purposes. Placing the checks early in the pipeline ensures security vulnerabilities are detected early on in the pipeline which follows the principles of shift-left security. A custom ECR image containing all terraform tools and software is used by the pipeline to speed up its execution time.
- Cost Estimation stage: An estimate of the cost of the resource to be deployed is done using Infracost, one of my favorite IaC tools. It can also be used to deduce a cost estimate of the change to be made to the environment. A report is emailed to subscribers and backed up to S3.
- Planning stage: Here a terraform plan of the infrastructure change is generated and stored as an artifact to be used at a later stage.
- Manual approval stage: For critical infrastructure a manual approval stage should be included for a careful review before making changes to your environment. The reviewer will receive an email notification for the approval
- Deployment stage: The reviewed plan is deployed to the target account after approval. The sample infrastructure deployed in this post is the classic 3-tier architecture below.  


## 3-tier webapp architecture deployed via pipeline
![3-tier webapp architecture](https://github.com/yemisprojects/DevOps-Portfolio-Projects/blob/main/cross-account-CI-CD-infrastructure/Images/3tier-webapp-architecture.png)
<h4 align="center"></h4>

## Deployment Pre-requisites
- Knowledge of Terraform, AWS, Python, Docker, Shell scripting
- Docker, Infracost ( v0.10.29) and Terraform (1.6.1) installed (1.6.0 crashes)
- Two AWS accounts and an IAM user with admin permissions.
- AWS CLI (2.2+) installed and configured for both accounts
- Access to the project files on my GitHub repo
- Email address for pipeline notifications
- Registered domain name

## Deployment Steps
See my free [medium blog post](link) for step by step guide

## Pipeline features
- <h4>Slack notifications</h4>
You will receive Slack notifications once the pipeline is triggered, and receive requests for manual approval or pipeline execution completes.

![Slack notifications](https://github.com/yemisprojects/DevOps-Portfolio-Projects/blob/main/cross-account-CI-CD-infrastructure/Images/Slack%20notifications.png)

- <h4>Test reports</h4>
Each CodeBuild project generates test reports. For example, the screenshot below shows a summary of the success rate of test cases for the security scans run by Checkov.

![Checkov summary report](https://github.com/yemisprojects/DevOps-Portfolio-Projects/blob/main/cross-account-CI-CD-infrastructure/Images/Checkov%20report%20summary.png)

- <h4>Infrastructure Cost estimations</h4>
Last but not least my favorite, the pipeline generates the snippet cost report shown below using Infracost. You can view the full report [here](https://github.com/yemisprojects/DevOps-Portfolio-Projects/blob/main/cross-account-CI-CD-infrastructure/report%20samples/cost%20report.pdf)

![Infracost report](https://github.com/yemisprojects/DevOps-Portfolio-Projects/blob/main/cross-account-CI-CD-infrastructure/Images/cost%20report.png)

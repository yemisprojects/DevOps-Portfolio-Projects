FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf update \
    && set -ex \
    && dnf install -y -q openssl tar wget which unzip git tar 
   
RUN useradd codebuild-user

ARG TERRAFORM_VERSION=1.6.1
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip -q terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin \
    && rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

ARG TFLINT_VERSION=0.43.0
RUN wget -q https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip -O tflint_linux_amd64.zip \
    && unzip -q tflint_linux_amd64.zip -d /usr/bin \
    && rm -f tflint_linux_amd64.zip

ARG TERRASCAN_VERSION=1.17.0
RUN curl -LSso terrascan.tar.gz https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz   \
    && tar -xzf terrascan.tar.gz -C /usr/bin \
    && rm -f terrascan.tar.gz

##INFRACOST
RUN curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | bash

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip

RUN dnf install -y python3-pip \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN pip install --no-cache-dir wheel boto3 checkov

RUN terraform -version \
&& tflint --version \
&& aws --version \
&& infracost -v \
&& checkov -v \
&& terrascan version \
&& pip --version \
&& python --version

USER codebuild-user
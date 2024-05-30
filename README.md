# AWS-Minecraft-Server
A Simple Minecraft Server Hosted on AWS using the latest amazon AMI

This cloud application is built on Hashcorps Terraform, and open source infrastructure as code tool used to spin up and spin down infrastructure from cloud platforms such as AWS, Azure and GCP.

To install Terraform follow the steps in this link: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
to install AWS CLI follow the steps in this link: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# How to Run

Deploying this infrastructure on AWS requires you to have Command line access into an AWS account with its credentials located in a file at ~/.aws/credentials. 

This command line access profile must be saved as minecraft_prod or if you wish to have a second naming conventions please update the ./aws-infrastructure/locals.tf file changing the aws_profile line from minecraft_prod to your chosen aws profile name.

Simple:

1. Use ``` terraform init ``` to initialise the terraform build files
2. Use ``` terraform plan ``` to verify that the infrastructure deployed is correct and up to standard
3. Use ``` terraform deploy ``` to deploy the infrastructure on the required aws account


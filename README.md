# AWS-Minecraft-Server
A Minecraft Server Hosted on AWS with Discord bot monitoring and request handling

This cloud application is built on Hashcorps Terraform, and open source infrastructure as code tool used to spin up and spin down infrastructure from cloud platforms such as AWS, Azure and GCP.

To install Terraform follow the steps in this link: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

To use the make file contained in this repository, it requires Docker. For more specifics on docker and how to install, follow this link: https://docs.docker.com/get-docker/

# Infrastructure Diagram

![alt text](./Images/AWS%20Minecraft%20Server%20(infrastructure).jpg)

# How to Run

To run this applications the terraform script to deploy the infrastructure please make sure you have docker and terraform and make installed by following the links above.

Deploying this infrastructure on AWS requires you to have Command line access into an AWS account with its credentials located in a file at ~/.aws/credentials.

This command line access profile must be saved as minecraft_prod or if you wish to have a second naming conventions please update the ./aws-infrastructure/locals.tf file changing the aws_profile line from minecraft_prod to your chosen aws profile name.

Once all the requirements have been installed to create the infrastructure on your aws profile make sure it compiles with:

``` bash
make init
```

If it successfully compiles then run

``` bash
make plan
```

followed by:

``` bash
make apply
```

which will deploy this infrastructure onto your aws account.

If you with to destroy this infrastructure, terraform allows you to do so quickly and easily with:

``` bash
make destroy
```

However make sure not to delete any terraform files which have been created by this application in this directory, otherwise terraform will not know what infrastructure has been deployed or deleted.
terraform {
  required_version = ">= 1.8.4"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.51.1"
    }
  }
}

module "mineraft-vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "minecraft-vpc"
    cidr = "192.168.0.0/16"

    azs = ["ap-southeast-2a"]
    public_subnets = ["192.168.1.0/24"]

    tags = {
        Terraform = "true"
        Environemnt = "Prod"
    }
}
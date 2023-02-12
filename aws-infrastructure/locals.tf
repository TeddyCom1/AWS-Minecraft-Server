locals {
  env = {
    default = {
        aws_profile         = "minecraft_prod"
        aws_region          = "ap-southeast-2"
        vpc-cidr_block      = "192.168.0.0/16"
        subnet-cidr_block   = "192.168.69.0/24"
        minecraft-private_ip          = "192.168.69.12"
        instance_type       = "t3.micro"
        security_groups = {
            minecraft-sg = {
                ingress = [25565]
                egress  = [25565]
        }
        }
        
    }
  }

  workspace = local.env[terraform.workspace]
}
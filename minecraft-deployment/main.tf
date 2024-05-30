terraform {
  required_version = ">= 1.8.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.51.1"
    }
  }
}

#Finds the latest AWS Amazon Linux AMI

data "aws_ami" "amazon-linux-latest" {
  most_recent = true
  owners      = [ "amazon" ]

  filter {
    name      = "virtualization-type"
    values    = [ "hvm" ]
  }

  filter {
    name      = "architecture"
    values    = [ "x86_64" ]
  }
}

#To allow for SSM access in the case of emergency

resource "aws_iam_instance_profile" "ssm-instance-profile" {
  name = "ec2_profile"
  role = aws_iam_role.ssm-instance-role.name
}

resource "aws_iam_role" "ssm-instance-role" {
  name        = "ssm-role-${random_string.idk.result}"
  description = "The role for the developer resources EC2"

  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": {
            "Effect": "Allow",
            "Principal": {"Service": "ec2.amazonaws.com"},
            "Action": "sts:AssumeRole"
        }
    }
    EOF
  tags = {
    stack = "test"
  }
}

resource "aws_iam_role_policy_attachment" "ssm-instance-policy" {
  role       = aws_iam_role.ssm-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_security_group" "minecraft-server-sg" {
  name = "minecraft-server-sg"
  description = "allow all inbound connections to port 25565"
  vpc_id = var.vpc_id

  ingress = {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_instance" "minecraft-server" {
  ami                     = data.aws_ami.amazon-linux-latest.id
  instance_type           = var.instance_size
  iam_instance_profile    = aws_iam_instance_profile.ssm-instance-profile.name
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [ aws_security_group.minecraft-server-sg.id ]
  user_data               = file("./user-data/minecraft-installation.sh")

  tags = {
    Name = "minecraft-server"
  }
}
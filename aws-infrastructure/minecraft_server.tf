resource "aws_vpc" "minecraft-vpc" {
  cidr_block = local.workspace.vpc-cidr_block
  tags = {
    Name = "minecraft-vpc"
  }
}

resource "aws_internet_gateway" "minecraft-gw" {
    vpc_id = aws_vpc.minecraft-vpc.id
}

resource "aws_subnet" "minecraft-public-subnet" {
    vpc_id                  = aws_vpc.minecraft-vpc.id
    cidr_block              = local.workspace.subnet-cidr_block
    map_public_ip_on_launch = true

    depends_on              = [aws_internet_gateway.minecraft-gw]
}

resource "aws_instance" "minecraft-server" {
    ami             = data.aws_ami.ubuntu.id
    security_groups = [aws_security_group.minecraft-sg.id]
    instance_type   = local.workspace.instance_type
    private_ip      = local.workspace.minecraft-private_ip
    subnet_id       = aws_subnet.minecraft-public-subnet.id
}

resource "aws_eip" "minecraft-public-ip" {
  vpc                       = true
  associate_with_private_ip = local.workspace.minecraft-private_ip
  depends_on                = [aws_internet_gateway.minecraft-gw]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-kinetic-22.10-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


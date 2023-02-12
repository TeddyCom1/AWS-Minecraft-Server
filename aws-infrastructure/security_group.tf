resource "aws_security_group" "minecraft-sg" {
  name   = "minecraft-sg"
  vpc_id = aws_vpc.vpc-minecraft.id

  dynamic "ingress" {
    for_each = local.workspace.security_groups.minecraft-sg.ingress
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
    }
  }

  dynamic "egress" {
    for_each = local.workspace.security_groups.minecraft-sg.egress
    iterator = port
    content {
      from_port = port.value
      to_port   = port.value
      protocol  = "tcp"
    }
  }
}
resource "aws_instance" "roboshop" {
  for_each = var.instances
  ami = var.ami_id
  instance_type = each.value
  tags = {
    Name = each.key # Assigns the instance name
  }
  
}


# output "aws_instance_info" {

#   value = aws_instance.roboshop.public_ip
  
# }

resource "aws_security_group" "roboshop" {
  name        = "roboshop"
  description = "Allow http https ssh"

  # Dynamic ingress block for multiple rules
  dynamic "ingress" {
    for_each = var.ingress
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  # Static egress block
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "roboshop"
  }
}

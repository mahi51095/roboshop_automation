variable "ami_id" {
  type        = string
  default     = "ami-0b4f379183e5706b9"
 
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "type of instances to deploy"
}

variable "instance_name" {
  type    = string
  default = "roboshop-instance"  # Optional default value
}

variable "instances" {
    type = map(string)
    default = {
        MongoDB = "t3.medium"
        mysql = "t3.medium"
        rabbitMQ = "t2.micro"
        redis = "t2.micro"
        catalogue = "t2.micro"
        user = "t2.micro"
        cart = "t2.micro"
        shipping = "t2.micro"
        payments = "t2.micro"
        web = "t2.micro"
    }
}

variable "zone_id" {
    default = "Z0920191HCM5A5VS0LQB"
}

variable "domain" {
    default = "joindevops.sbs"
}

variable "ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allowing port 80 from public"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allowing port 443 from public"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allowing port 22 from public"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

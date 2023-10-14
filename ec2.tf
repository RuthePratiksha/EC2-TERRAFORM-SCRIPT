



# resource "tls_private_key" "rsa_4096" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }


# variable "key_name" {
#   description = "Name of the SSH key pair"
# }


# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer-key"
#   public_key = "tls_private_key.rsa_4096.public_key_openssh"
# }

# // Save PEM file locally
# resource "local_file" "private_key" {
#   content  = tls_private_key.rsa_4096.private_key_pem
#   filename = var.key_name
# }


# Create a security group
resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_instance" {
  ami                    = "ami-0a5ac53f63249fba0"
  instance_type          = "t2.micro"
  key_name      = data.aws_key_pair.sahas_key_pair.key_name
  user_data = file("shell.sh")
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  tags = {
    Name = "public_instance"
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
}


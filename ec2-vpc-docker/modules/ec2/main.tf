resource "aws_instance" "web" {
  ami           = "ami-07c1b39b7b3d2525d"
  instance_type = "t2.micro"
  key_name = var.shh-key-name
  depends_on = [ aws_key_pair.ec2-key, local_file.ssh-key ]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id = var.public_subnet
  associate_public_ip_address = true
  user_data = file("scripts/setup.sh")
  tags = {
    Name = "Ec2-vpc"
  }
  
}


# RSA key of size 4096 bits
resource "tls_private_key" "rsa-4096-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2-key" {
    key_name = var.shh-key-name
    public_key = tls_private_key.rsa-4096-key.public_key_openssh
}

resource "local_file" "ssh-key" {
    filename = var.shh-key-name
    content = tls_private_key.rsa-4096-key.private_key_openssh
    provisioner "local-exec" {
    command = "chmod 400 ${var.shh-key-name}"
  }
}

resource "aws_security_group" "ec2_sg" {
    name = "Security group of the ec2 instance"
    description = "security group of the ec2 instance"

    vpc_id      = var.vpc_id#CHANGE THIS TO THE VPC

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks=["::/0"]
    }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name= "ec2-security-group"
  }
}

output "ip" {
  value = aws_instance.web.public_ip
}
output "dns" {
  value = aws_instance.web.public_dns
}


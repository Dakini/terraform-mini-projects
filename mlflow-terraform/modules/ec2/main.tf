resource "aws_instance" "mlflow-instance" {
    ami = "ami-046d5130831576bbb" #ec2-user ami
    instance_type = "t2.large"
    key_name = var.filename
    
    depends_on = [ aws_key_pair.mlflow-key, local_file.mlflow-key ]
    
    iam_instance_profile = aws_iam_instance_profile.ec2-instance-profile.id
    security_groups = [aws_security_group.ec2_sg.name]
    tags ={
        Name="mlflow-instance"
    }
    user_data = file("scripts/ec2_setup.sh")
    
}

resource "aws_security_group" "ec2_sg" {
    name = "Security group of the ec2 instance"
    description = "security group of the ec2 instance"

    vpc_id      = "your-vpc"

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks=["::/0"]
    }

    ingress {
        description = "Mlflow-Server"
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks=["::/0"]
    }

    ingress {
        description = "jupyter notebook"
        from_port = 8888
        to_port = 8888
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

output "ec2-ip" {
  value = aws_instance.mlflow-instance.public_ip
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "mlflow-key" {
  key_name   = var.filename
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "local_file" "mlflow-key" {
  content  = tls_private_key.rsa.private_key_openssh
  filename = var.filename
  provisioner "local-exec" {
    command = "chmod 400 ${var.filename}"
  }
}
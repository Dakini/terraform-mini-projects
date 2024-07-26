resource "aws_db_instance" "mlflow-db" {
  engine               = "postgres"
  engine_version       = "16"
  allocated_storage    = 20
  storage_type = "gp2"
  identifier = "mlflowdb"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  instance_class       = "db.t3.micro"
  publicly_accessible = false
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.mlflow_rds_sg.id]
  tags = {
    Name= "My mlfow db"
  }
}

# need to add securiy group with ports 5432
resource "aws_security_group" "mlflow_rds_sg" {
  name = "security group for RDS for Mlflow"
  description = "security group for RDS for Mlflow"
  vpc_id      = "your-vpc"

  ingress {
    description="Output port for the db"
    from_port=5432
    to_port=5432
    protocol="tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name= "mlflow_rds_sg"
  }
}

output "rds-ip" {
  value = aws_db_instance.mlflow-db.address
}
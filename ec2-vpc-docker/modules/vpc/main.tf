# create vpc
resource "aws_vpc" "main-vpc" {
    cidr_block = "10.0.0.0/16"
  tags = {
    Name="terraform vpc"
  }
}
#create subnets
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main-vpc.id 
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main-vpc.id 
  cidr_block = "10.0.2.0/24"
}
# create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name="Internet gateway for terraform "
  }
}

#create a route table 
resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.main-vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#create the association for the public subnet
resource "aws_route_table_association" "SubnetAssociations" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.route_table.id
  
}

output "vpc_id" {
    value = aws_vpc.main-vpc.id
}
output "public_subnet" {
  value = aws_subnet.public_subnet.id
}
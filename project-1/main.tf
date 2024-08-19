provider "aws"{
    region = "us-east-1"
}
# deploy VPC-1
resource "aws_vpc" "vpc-1" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name="vpc-1"
    }
  
}
# deploy prive Subnet 
resource "aws_subnet" "subnet-1-priver" {
 vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-1-priver"
  }
}
# deploy public Subnet 
resource "aws_subnet" "subnet-2-public" {
 vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-2-public"
  }
}
# deploy internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "igw"
  }
}
# deploy RoutTable 
resource "aws_route_table" "RoutTable" {
vpc_id = aws_vpc.vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    name = "RoutTable"
  }
}
# deploy RoutTable association
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.subnet-2-public.id
  route_table_id = aws_route_table.RoutTable.id
}
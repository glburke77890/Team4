# This creates the VPC
resource "aws_vpc" "team4-vpc" {
  cidr_block           = "40.40.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "Team4"
  }
}
# This creates the Internet Gateway
resource "aws_internet_gateway" "team4-igw" {
  vpc_id = aws_vpc.team4-vpc.id
}
# This creates the first public subnet in AZ1 (subnet 1)
resource "aws_subnet" "team4-pub1" {
  vpc_id            = aws_vpc.team4-vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "40.40.42.0/24"
  map_public_ip_on_launch = true
}
# This creates the second public subnet is AZ2 (subnet 2)
resource "aws_subnet" "team4-pub2" {
  vpc_id            = aws_vpc.team4-vpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "40.40.43.0/24"
  map_public_ip_on_launch = true
}

# This creates the route table for public subnet to get out to the internet
resource "aws_route_table" "team4-pubRT" {
  vpc_id = aws_vpc.team4-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.team4-igw.id
  }
}
# This associates the public subnet 1 with the route table
resource "aws_route_table_association" "team4-pubrt1" {
  subnet_id      = aws_subnet.team4-pub1.id
  route_table_id = aws_route_table.team4-pubRT.id
}
# This associates the public subnet 2 with the route table
resource "aws_route_table_association" "team4-pubrt2" {
  subnet_id      = aws_subnet.team4-pub2.id
  route_table_id = aws_route_table.team4-pubRT.id
}
resource "aws_security_group" "Team4-sg" {
  description = "allow all"
  vpc_id = aws_vpc.team4-vpc.id
}
resource "aws_security_group_rule" "t4allow" {
  security_group_id = aws_security_group.Team4-sg.id
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "allow"
}
resource "aws_security_group_rule" "t4allowout" {
  security_group_id = aws_security_group.Team4-sg.id
  type = "egress"
  protocol = "-1"
  from_port = 0
  to_port = 0
  cidr_blocks = ["0.0.0.0/0"]
  description = "allow out"
  
}


resource "aws_security_group" "tm4-eks" {
  
  
}
provider "aws" {
  region = "ap-southeast-3"

  default_tags {
    tags = {
      Owner = "nathanael"
      # Environment     = "Test"
      Service = "create-by-terraform"
      # HashiCorp-Learn = "aws-default-tags"
      Project = "test terraform"
    }
  }
}

resource "aws_vpc" "foodstore-vpc-tf" {
  cidr_block       = "10.2.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "foodstore-terraform"
  }
}

resource "aws_internet_gateway" "foodstore-tf-igw" {
  vpc_id = aws_vpc.foodstore-vpc-tf.id

  tags = {
    Name = "foodstore-tf-igw"
  }
}

resource "aws_subnet" "foodstore-tf-public-subnet" {
  vpc_id     = aws_vpc.foodstore-vpc-tf.id
  cidr_block = "10.2.1.0/24"

  tags = {
    Name = "foodstore-tf-public-subnet"
  }
}

resource "aws_route_table" "foodstore-tf-public-rtb" {
  vpc_id = aws_vpc.foodstore-vpc-tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.foodstore-tf-igw.id
  }

  tags = {
    Name = "foodstore-tf-public-rtb"
  }
}

resource "aws_route_table_association" "rtb-public-association" {
  subnet_id      = aws_subnet.foodstore-tf-public-subnet.id
  route_table_id = aws_route_table.foodstore-tf-public-rtb.id
}


resource "aws_subnet" "foodstore-tf-public-subnet2" {
  vpc_id     = aws_vpc.foodstore-vpc-tf.id
  cidr_block = "10.2.2.0/24"

  tags = {
    Name = "foodstore-tf-public-subnet2"
  }
}

resource "aws_route_table" "foodstore-tf-public-rtb2" {
  vpc_id = aws_vpc.foodstore-vpc-tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.foodstore-tf-igw.id
  }

  tags = {
    Name = "foodstore-tf-public-rtb2"
  }
}

resource "aws_route_table_association" "rtb-public-association2" {
  subnet_id      = aws_subnet.foodstore-tf-public-subnet2.id
  route_table_id = aws_route_table.foodstore-tf-public-rtb2.id
}

resource "aws_subnet" "foodstore-tf-private-subnet" {
  vpc_id     = aws_vpc.foodstore-vpc-tf.id
  cidr_block = "10.2.3.0/24"

  tags = {
    Name = "foodstore-tf-private-subnet"
  }
}

resource "aws_route_table" "foodstore-tf-private-rtb" {
  vpc_id = aws_vpc.foodstore-vpc-tf.id

  tags = {
    Name = "foodstore-tf-private-rtb"
  }
}

resource "aws_route_table_association" "rtb-private-association" {
  subnet_id      = aws_subnet.foodstore-tf-private-subnet.id
  route_table_id = aws_route_table.foodstore-tf-private-rtb.id
}

resource "aws_subnet" "foodstore-tf-private-subnet2" {
  vpc_id     = aws_vpc.foodstore-vpc-tf.id
  cidr_block = "10.2.4.0/24"

  tags = {
    Name = "foodstore-tf-private-subnet2"
  }
}

resource "aws_route_table" "foodstore-tf-private-rtb2" {
  vpc_id = aws_vpc.foodstore-vpc-tf.id

  tags = {
    Name = "foodstore-tf-private-rtb2"
  }
}

resource "aws_route_table_association" "rtb-private-association2" {
  subnet_id      = aws_subnet.foodstore-tf-private-subnet2.id
  route_table_id = aws_route_table.foodstore-tf-private-rtb2.id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.foodstore-vpc-tf.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.foodstore-tf-public-subnet.id
}

output "public_subnet_id2" {
  description = "The ID of the public subnet"
  value       = aws_subnet.foodstore-tf-public-subnet2.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.foodstore-tf-private-subnet.id
}

output "private_subnet_id2" {
  description = "The ID of the private subnet"
  value       = aws_subnet.foodstore-tf-private-subnet2.id
}

output "public-rtb" {
  description = "The ID of the public rtb"
  value = aws_route_table.foodstore-tf-public-rtb.id
}

output "public-rtb2" {
  description = "The ID of the public rtb 2"
  value = aws_route_table.foodstore-tf-public-rtb2.id
}

output "private-rtb" {
  description = "The ID of the private rtb"
  value = aws_route_table.foodstore-tf-private-rtb.id
}

output "private-rtb2" {
  description = "The ID of the public rtb 2"
  value = aws_route_table.foodstore-tf-private-rtb2.id
}





# resource "aws_route" "public-igw" {
#   route_table_id = aws_route_table.foodstore-tf-public-rtb.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id = aws_internet_gateway.foodstore-tf-igw.id
  
# }

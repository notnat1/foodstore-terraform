provider "aws" {
  region = "ap-southeast-3"
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

data "terraform_remote_state" "eip" {
  backend = "local"

  config = {
    path = "../eip/terraform.tfstate"
  }
}

resource "aws_nat_gateway" "foodstore-tf-ngw" {
  allocation_id = data.terraform_remote_state.eip.outputs.eip_allocation_id
  subnet_id     = data.terraform_remote_state.vpc.outputs.public_subnet_id

  tags = {
    Name = "foodstore-ngw-tf"
  }
}

resource "aws_route" "private_nat_gateway_route" {
  route_table_id         = data.terraform_remote_state.vpc.outputs.private-rtb
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.foodstore-tf-ngw.id
}

resource "aws_route" "private_nat_gateway_route2" {
  route_table_id         = data.terraform_remote_state.vpc.outputs.private-rtb2
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.foodstore-tf-ngw.id
}

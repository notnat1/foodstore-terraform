provider "aws" {
  region = "ap-southeast-3"
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

resource "aws_security_group" "foodstore-instance-sg" {
  name        = "foodstore-instance-sg-tf"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "Allow HTTP from the load balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.foodstore-lb-sg.id]
  }

  ingress {
    description     = "Allow SSH only from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.foodstore-bastion-sg.id] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "foodstore-instance-sg-tf"
  }
}

resource "aws_security_group" "foodstore-lb-sg" {
  name        = "foodstore-lb-sg-tf"
  description = "Allow HTTP traffic to the load balancer"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
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

  tags = {
    Name = "foodstore-lb-sg-tf"
  }
}

resource "aws_security_group" "foodstore-bastion-sg" {
  name        = "foodstore-bastion-sg-tf"
  description = "Allow SSH traffic for bastion host"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "foodstore-bastion-sg-tf"
  }
}

resource "aws_security_group" "foodstore-master-sg" {
  name        = "foodstore-master-sg-tf"
  description = "Allow SSH from bastion and internal traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description     = "Allow SSH from the bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.foodstore-bastion-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "foodstore-master-sg-tf"
  }
}

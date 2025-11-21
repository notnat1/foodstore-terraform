provider "aws" {
  region = "ap-southeast-3"
}

data "terraform_remote_state" "vpc-state" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

resource "aws_eip" "foodstore-tf-eip" {
  domain = "vpc"

  tags = {
    Name = "foodstore-eip-tf"
  }
}

output "eip_allocation_id" {
  description = "The allocation ID of the EIP"
  value       = aws_eip.foodstore-tf-eip.id
}

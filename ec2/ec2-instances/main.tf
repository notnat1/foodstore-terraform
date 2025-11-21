data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

resource "aws_instance" "foodstore-bastion-host-tf" {
  ami           = "ami-0f60ebc551a693514"
  instance_type = "t3.small"
  subnet_id     = data.terraform_remote_state.vpc.outputs.public_subnet_id
  vpc_security_group_ids = [aws_security_group.foodstore-bastion-sg.id]
  iam_instance_profile = aws_iam_instance_profile.bastion_profile-tf.name
  associate_public_ip_address = true


  tags = {
    Name = "bastion-host-foodstore"
  }
}

resource "aws_instance" "foodstore-master-tf" {
  ami           = "ami-0f60ebc551a693514"
  instance_type = "t3.micro"
  subnet_id     = data.terraform_remote_state.vpc.outputs.private_subnet_id
  vpc_security_group_ids = [aws_security_group.foodstore-master-sg.id]
  iam_instance_profile = aws_iam_instance_profile.master_profile-tf.name

  tags = {
    Name = "master-node-tf"
  }
}

resource "aws_launch_template" "foodstore-launch-template-tf" {
  name_prefix   = "foodstore-lt-tf"
  image_id      = "ami-097e0241c8d5c55a5"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.foodstore-instance-sg.id]

  tags = {
    Name = "foodstore-launch-template-tf"
  }
}
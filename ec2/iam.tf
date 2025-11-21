resource "aws_iam_role" "jenkins-magang-bastion-role-tf" {
  name = "jenkins-magang-bastion-foodstore"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "bastion_profile-tf" {
  name = "jenkins-magang-bastion-foodstore"
  role = aws_iam_role.jenkins-magang-bastion-role-tf.name
}

resource "aws_iam_role" "jenkins-magang-master-role-tf" {
  name = "jenkins-magang-foodstore-instanceprofile"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "master_profile-tf" {
  name = "jenkins-magang-foodstore-instanceprofile"
  role = aws_iam_role.jenkins-magang-master-role-tf.name
}

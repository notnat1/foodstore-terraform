resource "aws_autoscaling_group" "foodstore-asg-tf" {
  name                = "foodstore-asg-tf"
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [data.terraform_remote_state.vpc.outputs.private_subnet_id]

  launch_template {
    id      = aws_launch_template.foodstore-launch-template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.foodstore-tg-tf.arn]

  tag {
    key                 = "Name"
    value               = "foodstore-asg-instance-tf"
    propagate_at_launch = true
  }
}

output "autoscaling_group_name" {
  description = "nama asg"
  value       = aws_autoscaling_group.foodstore-asg-tf.name
}
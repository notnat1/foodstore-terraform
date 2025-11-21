provider "aws" {
  region = "ap-southeast-3"
}

data "terraform_remote_state" "ec2" {
  backend = "local"

  config = {
    path = "../ec2/terraform.tfstate"
  }
}

resource "aws_sns_topic" "foodstore-alarms-tf" {
  name = "foodstore-alarms-tf"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "foodstore-high-cpu-utilization-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "This metric monitors EC2 CPU utilization for the ASG."
  alarm_actions       = [aws_sns_topic.foodstore-alarms-tf.arn]
  ok_actions          = [aws_sns_topic.foodstore-alarms-tf.arn]

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.autoscaling_group_name
  }
}

resource "aws_cloudwatch_dashboard" "foodstore-dashboard" {
  dashboard_name = "FoodStore-Dashboard-tf"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "AutoScalingGroupName",
              data.terraform_remote_state.ec2.outputs.autoscaling_group_name
            ]
          ]
          period = 300
          stat   = "Average"
          region = "ap-southeast-3"
          title  = "EC2 CPU Utilization"
        }
      }
    ]
  })
}

output "cloudwatch_dashboard_name" {
  description = "The name of the CloudWatch Dashboard"
  value       = aws_cloudwatch_dashboard.foodstore-dashboard.dashboard_name
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic for alarms"
  value       = aws_sns_topic.foodstore-alarms.arn
}
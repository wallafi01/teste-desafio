output "codedeploy_app_name" {
  description = "The name of the CodeDeploy application"
  value       = aws_codedeploy_app.app_challenge.name
}

output "codedeploy_deployment_group_name" {
  description = "The name of the CodeDeploy deployment group"
  value       = aws_codedeploy_deployment_group.group_app_challenge
}

output "codedeploy_role_arn" {
  description = "The ARN of the IAM role used by CodeDeploy"
  value       = aws_iam_role.codedeploy_role.arn
}

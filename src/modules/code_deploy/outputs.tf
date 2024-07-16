# output "codedeploy_app_name" {
#   description = "The name of the CodeDeploy application"
#   value       = aws_codedeploy_app.name_app.name
# }

# output "codedeploy_deployment_group_name" {
#   description = "The name of the CodeDeploy deployment group"
#   value       = aws_codedeploy_deployment_group.deployment_group_name.name
# }

output "codedeploy_role_arn" {
  description = "The ARN of the IAM role used by CodeDeploy"
  value       = aws_iam_role.codedeploy_role.arn
}

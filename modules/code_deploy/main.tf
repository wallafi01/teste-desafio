resource "aws_codedeploy_app" "app_challenge" {
  name             = var.name_app
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "group_app_challenge" {
  app_name              = aws_codedeploy_app.app_challenge.name
  deployment_group_name = var.deployment_group_name
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_config_name = "CodeDeployDefault.OneAtATime"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = var.instance_name
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

variable "name_prefix" {}
variable "environment" {}
variable "stack_name" {}
variable "deploy_code" {}
variable "arn" {}

resource "aws_codedeploy_app" "application" {
    name = "${var.stack_name}_${var.environment}_${var.deploy_code}"
}

resource "aws_codedeploy_deployment_group" "deploy_group" {
    app_name = "${aws_codedeploy_app.application.name}"
    deployment_group_name = "${var.stack_name}_${var.environment}_${var.deploy_code}"
    service_role_arn = "${var.arn}"

    ec2_tag_filter {
        key = "Name"
        type = "KEY_AND_VALUE"
        value = "${var.name_prefix}app"
    }

    # trigger_configuration {
    #     trigger_events = ["DeploymentFailure"]
    #     trigger_name = "rb-trigger"
    #     trigger_target_arn = "rb-topic-arn"
    # }
}


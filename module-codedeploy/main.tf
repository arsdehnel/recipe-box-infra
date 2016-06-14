variable "name_prefix" {}
variable "environment" {}
variable "stack_name" {}

resource "aws_codedeploy_app" "rb_api" {
    name = "${var.stack_name}__deploy_app"
}

resource "aws_codedeploy_deployment_group" "rb" {
    app_name = "${aws_codedeploy_app.rb_api.name}"
    deployment_group_name = "${var.stack_name}__deploy_grp"
    service_role_arn = "${aws_iam_role.deploy_role.arn}"

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

resource "aws_iam_role" "deploy_role" {
    name = "${var.stack_name}deploy_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "deploy_policy" {
    name = "${var.stack_name}deploy_policy"
    role = "${aws_iam_role.deploy_role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:CompleteLifecycleAction",
                "autoscaling:DeleteLifecycleHook",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLifecycleHooks",
                "autoscaling:PutLifecycleHook",
                "autoscaling:RecordLifecycleActionHeartbeat",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "tag:GetTags",
                "tag:GetResources"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


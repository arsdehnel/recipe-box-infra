variable "name_prefix" {}
variable "stack_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "instance_id" {}
variable "instance_code" {}

resource "aws_security_group" "elb" {
  name        = "${var.name_prefix}sg_${var.instance_code}_elb"
  description = "Application ELB security"
  vpc_id      = "${var.vpc_id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    stack_name = "${var.stack_name}"
    environment = "${var.environment}"
  }    

}

resource "aws_elb" "elb" {
  name = "${var.stack_name}${var.instance_code}-elb"

  subnets         = ["${var.subnet_id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${var.instance_id}"]

  listener {
    instance_port     = 4001
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 5
    timeout = 60
    target = "TCP:4001"
    interval = 90
  }

  tags {
    stack_name = "${var.stack_name}"
    environment = "${var.environment}"
  }    

}
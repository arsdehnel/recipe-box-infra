variable "application" {}
variable "environment" {}
variable "vpc_id" {}
variable "public_subnet_id" {}
variable "app_instance_id" {}

resource "aws_security_group" "elb" {
  name        = "sg_app_elb"
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

}

resource "aws_elb" "elb" {
  name = "ELB"

  subnets         = ["${var.public_subnet_id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${var.app_instance_id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 5
    timeout = 60
    target = "TCP:80"
    interval = 90
  }

  tags {
    Application = "${var.application}"
    Environment = "${var.environment}"
  }

}

output "sec_grp_id" {
  value = "${aws_security_group.elb.id}"
}
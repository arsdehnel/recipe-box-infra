variable "name_prefix" {}
variable "stack_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "key_pair_id" {}
variable "subnet_id" {}
variable "bastion_ami" {}
variable "instance_type" {}

resource "aws_security_group" "bastion" {
  name = "${var.name_prefix}bastion"
  description = "Allow SSH traffic from the internet"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    stack_name = "${var.stack_name}"
    environment = "${var.environment}"
  }  

}

resource "aws_security_group" "allow_access_from_bastion" {
  name                    = "${var.name_prefix}access_from_bastion"
  description             = "Grants access to SSH from bastion server"
  vpc_id                  = "${var.vpc_id}"

  ingress {
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    security_groups       = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  tags {
    stack_name            = "${var.stack_name}"
    environment           = "${var.environment}"
  }  
}

resource "aws_instance" "bastion" {
  ami                     = "${var.bastion_ami}"
  instance_type           = "${var.instance_type}"
  subnet_id               = "${var.subnet_id}"
  key_name                = "${var.key_pair_id}"
  vpc_security_group_ids  = ["${aws_security_group.bastion.id}"]

  tags {
    Name = "${var.name_prefix}bastion"
    stack_name = "${var.stack_name}"
    environment = "${var.environment}"
  }
}
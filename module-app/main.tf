# variable "access_key" {}
# variable "secret_key" {}
# variable "region" {}
variable "name_prefix" {}
variable "stack_name" {}
variable "environment" {}
variable "private_key_path" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "key_pair_id" {}
variable "app_ami" {}
variable "elb_sec_grp_id" {}
variable "bastion_ip" {}
# variable "secret_file_path" {}

resource "aws_security_group" "app" {
  name        = "${var.name_prefix}app"
  description = "Public app security"
  vpc_id      = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # internet traffic
  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [ "${var.elb_sec_grp_id}" ]
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

resource "aws_instance" "app" {

    connection {
        # bastion_host = "${var.bastion_ip}"
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }

	instance_type               = "t2.small"
    ami                         = "${var.app_ami}"
	vpc_security_group_ids      = ["${aws_security_group.app.id}"]
    key_name                    = "${var.key_pair_id}"
	subnet_id                   = "${var.subnet_id}"
    associate_public_ip_address = true

    provisioner "remote-exec" {
        inline = [
          "echo \"machine ready...\""
        ]
    }

    provisioner "local-exec" {
        command = "ssh -i ${var.private_key_path} -o StrictHostKeyChecking=no ubuntu@${self.public_ip}"
    }

    # push the startup script to the remote and run it
    provisioner "remote-exec" {
        script = "${path.module}/startup.sh"
    }

    tags {
        Name = "${var.name_prefix}app"
        stack_name = "${var.stack_name}"
        environment = "${var.environment}"
    }

}
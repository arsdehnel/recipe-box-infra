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

resource "aws_security_group" "application" {
  name        = "${var.name_prefix}app"
  description = "Internal app security"
  vpc_id      = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
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

resource "aws_instance" "application" {

    connection {
        bastion_host = "${var.bastion_ip}"
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }

	instance_type               = "t2.micro"
    ami                         = "${var.app_ami}"
	vpc_security_group_ids      = ["${aws_security_group.application.id}"]
    key_name                    = "${var.key_pair_id}"
	subnet_id                   = "${var.subnet_id}"
    associate_public_ip_address = true

    # provisioner "remote-exec" {
    #     script = "~/Projects/products/gq-infra/module-app/startup.sh"
    # }

	# provisioner "remote-exec" {
 #    	inline = [
	# 		"sudo apt-get -y update",
	# 		"sudo apt-get -y install nginx",
	# 		"sudo service nginx start"
	# 	]
 #    }

    tags {
        Name = "${var.name_prefix}app"
        stack_name = "${var.stack_name}"
        environment = "${var.environment}"
    }

}
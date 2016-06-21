variable "access_key" {}
variable "secret_key" {}
variable "region" {}
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
variable "secret_file_path" {}

resource "aws_security_group" "phoenix" {
  name        = "${var.name_prefix}phoenix"
  description = "Internal app security"
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
    from_port       = 4001
    to_port         = 4001
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [ "${var.elb_sec_grp_id}" ]
  }

  # # RDP access for CodeDeploy
  # ingress {
  #   from_port       = 3389
  #   to_port         = 3389
  #   protocol        = "tcp"
  #   cidr_blocks     = ["0.0.0.0/0"]
  # }

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

resource "aws_instance" "phoenix" {

    connection {
        # bastion_host = "${var.bastion_ip}"
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }

	instance_type               = "t2.small"
    ami                         = "${var.app_ami}"
	vpc_security_group_ids      = ["${aws_security_group.phoenix.id}"]
    key_name                    = "${var.key_pair_id}"
	subnet_id                   = "${var.subnet_id}"
    associate_public_ip_address = true

    # create a script that we will push to the remote to execute to initialize the codedeploy agent
    # provisioner "local-exec" {
    #     command = "${path.module}/create-startup.sh ${path.module}/startup-codedeploy.sh ${var.region} ${var.access_key} ${var.secret_key}"
    # }

    # doing just stupid command here so that it waits for the OS to be booted up on the remote machine so that the subsequent local-exec can scp to it
    provisioner "remote-exec" {
        inline = [
          "echo \"machine ready...\""
        ]
    }

    # copy up the prod "secrets" file that is not in git
    provisioner "local-exec" {
        command = "scp -i ~/.ssh/recipebox -o StrictHostKeyChecking=no ${var.secret_file_path} ubuntu@${self.public_ip}:/home/ubuntu"
    }

    # push that script to the remove and run it
    provisioner "remote-exec" {
        script = "${path.module}/startup.sh"
    }

    # # remove that script from the remote because it has our access keys in it
    # provisioner "remote-exec" {
    #     inline = [
    #         "rm startup.sh"
    #     ]
    # }

    # remove that script from our local because it has our access keys in it
    # provisioner "local-exec" {
    #     command = "rm ${path.module}/startup-codedeploy.sh"
    # }

    tags {
        Name = "${var.name_prefix}phoenix"
        stack_name = "${var.stack_name}"
        environment = "${var.environment}"
    }

}

# resource "aws_security_group_rule" "db_access" {

#     type        = "ingress"
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     # cidr_blocks = ["0.0.0.0/0"]

#     security_group_id = "sg-dd1b1aba"
#     source_security_group_id = "${aws_security_group.phoenix.id}"

# }
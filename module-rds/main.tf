variable "subnet_1" {}
variable "subnet_2" {}
variable "environment" {}
variable "stack_name" {}
variable "name"  {}
variable "name_prefix" {}
variable "vpc_id" {}

resource "aws_db_instance" "default" {
	allocated_storage    = 10
	engine               = "postgres"
	instance_class       = "db.t2.micro"
	name                 = "recipe_box"
	username             = "recipe_box"
	password             = "fvnNRYMxEv0l290i"
	db_subnet_group_name = "${aws_db_subnet_group.default.name}"
	vpc_security_group_ids = ["${aws_security_group.db.id}"]
}

resource "aws_security_group" "db" {
  name        = "${var.name_prefix}db"
  description = "db security"
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
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    self            = true
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

resource "aws_db_subnet_group" "default" {

    name = "main"
    description = "main db subnet group"
    subnet_ids = ["${var.subnet_1}","${var.subnet_2}"]

	tags {
		Name = "${var.name}"
		stack_name = "${var.stack_name}"
		environment = "${var.environment}"
    }
}
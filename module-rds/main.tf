variable "subnet_1" {}
variable "subnet_2" {}
variable "environment" {}
variable "stack_name" {}
variable "name"  {}

resource "aws_db_instance" "default" {
	allocated_storage    = 10
	engine               = "postgres"
	instance_class       = "db.t2.micro"
	name                 = "recipe_box"
	username             = "recipe_box"
	password             = "fvnNRYMxEv0l290i"
	db_subnet_group_name = "${aws_db_subnet_group.default.name}"
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
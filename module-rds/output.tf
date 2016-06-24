output "instance_id" {
	value = "${aws_db_instance.default.id}"
}
output "endpoint" {
	value = "${aws_db_instance.default.endpoint}"
}
output "instance_id" {
	value = "${aws_db_instance.default.id}"
}
output "endpoint" {
	value = "${aws_db_instance.default.endpoint}"
}
output "sec_grp_id" {
	value = "${aws_security_group.db.id}"
}
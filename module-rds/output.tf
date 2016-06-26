output "instance_id" {
	value = "${aws_db_instance.default.id}"
}
output "address" {
	value = "${aws_db_instance.default.address}"
}
output "sec_grp_id" {
	value = "${aws_security_group.db.id}"
}
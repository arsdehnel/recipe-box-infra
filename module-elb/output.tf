output "sec_grp_id" {
  value = "${aws_security_group.elb.id}"
}
output "dns" {
	value = "${aws_elb.elb.dns_name}"
}
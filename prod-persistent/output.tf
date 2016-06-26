output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
output "public_subnet_id" {
	value = "${module.public_subnet.id}"
}
output "db_sec_grp_id" {
	value = "${module.db.sec_grp_id}"
}
output "db_address" {
	value = "${module.db.address}"
}
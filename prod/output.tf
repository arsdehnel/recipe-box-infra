output "bastion_ip" {
  value = "${module.bastion.public_ip}"
}
output "elb_dns" {
	value = "${module.elb.dns}"
}
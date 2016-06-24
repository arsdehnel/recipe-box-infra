output "bastion_ip" {
  value = "${module.bastion.public_ip}"
}
output "api_elb_dns" {
	value = "${module.api_elb.dns}"
}
output "app_elb_dns" {
	value = "${module.app_elb.dns}"
}
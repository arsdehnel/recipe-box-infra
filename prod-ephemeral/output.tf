output "bastion_ip" {
  value = "${module.bastion.public_ip}"
}
output "api_elb_dns" {
	value = "${module.api_elb.dns}"
}
output "app_elb_dns" {
	value = "${module.app_elb.dns}"
}
output "api_ip" {
	value = "${module.api.public_ip}"
}
output "app_ip" {
	value = "${module.app.public_ip}"
}
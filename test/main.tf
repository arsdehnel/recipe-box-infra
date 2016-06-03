provider "aws" {
    access_key    = "${var.access_key}"
    secret_key    = "${var.secret_key}"
    region        = "${var.aws_region}"
}

resource "aws_key_pair" "keypair" {
  key_name        = "${var.key_name}" 
  public_key      = "${file(var.public_key_path)}"
}

module "vpc" {
  source          = "../module-vpc"
  
  environment     = "${var.environment}"
  stack_name      = "${var.stack_name}"
  name_prefix     = "${var.name_prefix}"
}

# module "bastion" {
#   source           = "../module-bastion"
  
#   environment      = "qa"
#   application      = "GoalQuest"
#   key_pair_id      = "${aws_key_pair.goalquest.id}"
#   bastion_ami      = "${lookup(var.aws_amis, var.aws_region)}"
#   vpc_id           = "${module.vpc.vpc_id}"
#   public_subnet_id = "${module.vpc.public_subnet_id}"
# }

# module "elb" {
#   source           = "../module-elb"

#   environment      = "qa"
#   application      = "GoalQuest"
#   vpc_id           = "${module.vpc.vpc_id}"
#   public_subnet_id = "${module.vpc.public_subnet_id}"
#   app_instance_id  = "${module.app.instance_id}"

# }

# module "app" {
#   source           = "../module-app"
  
#   environment      = "qa"
#   application      = "GoalQuest"
#   key_pair_id      = "${aws_key_pair.goalquest.id}"
#   app_ami          = "${lookup(var.aws_amis, var.aws_region)}"
#   vpc_id           = "${module.vpc.vpc_id}"
#   public_subnet_id = "${module.vpc.public_subnet_id}"
#   elb_sec_grp_id   = "${module.elb.sec_grp_id}"
#   bastion_ip       = "${module.bastion.public_ip}"
#   private_key_path = "${var.private_key_path}"
# }


# output "bastion_ip" {
#   value = "${module.bastion.public_ip}"
# }
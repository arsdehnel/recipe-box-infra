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

module "public_subnet" {
  source          = "../module-subnet"

  environment     = "${var.environment}"
  stack_name      = "${var.stack_name}"
  name            = "${var.name_prefix}public"
  az              = "us-west-2b"
  cidr            = "10.0.1.0/24"
  vpc_id          = "${module.vpc.vpc_id}"
  route_table_id  = "${module.vpc.main_route_table_id}"
  public          = true
}

module "bastion" {
  source            = "../module-bastion"
  
  environment       = "${var.environment}"
  stack_name        = "${var.stack_name}"
  name_prefix       = "${var.name_prefix}"

  key_pair_id       = "${aws_key_pair.keypair.id}"
  bastion_ami       = "${lookup(var.aws_linux_amis, var.aws_region)}"
  instance_type     = "t2.micro"
  vpc_id            = "${module.vpc.vpc_id}"
  subnet_id         = "${module.public_subnet.id}"
}

module "elb" {
  source            = "../module-elb"

  environment       = "${var.environment}"
  stack_name        = "${var.stack_name}"
  name_prefix       = "${var.name_prefix}"

  vpc_id            = "${module.vpc.vpc_id}"
  subnet_id         = "${module.public_subnet.id}"
  app_instance_id   = "${module.app.instance_id}"

}

module "app" {
  source            = "../module-app"
  
  environment       = "${var.environment}"
  stack_name        = "${var.stack_name}"
  name_prefix       = "${var.name_prefix}"

  key_pair_id       = "${aws_key_pair.keypair.id}"
  app_ami           = "${lookup(var.aws_linux_amis, var.aws_region)}"
  vpc_id            = "${module.vpc.vpc_id}"
  subnet_id         = "${module.public_subnet.id}"
  elb_sec_grp_id    = "${module.elb.sec_grp_id}"
  bastion_ip        = "${module.bastion.public_ip}"
  private_key_path  = "${var.private_key_path}"
}
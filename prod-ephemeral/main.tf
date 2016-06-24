provider "aws" {
    access_key    = "${var.access_key}"
    secret_key    = "${var.secret_key}"
    region        = "${var.aws_region}"
}

module "bastion" {
  source            = "../module-bastion"
  
  environment       = "${var.environment}"
  stack_name        = "${var.stack_name}"
  name_prefix       = "${var.name_prefix}"

  key_pair_id       = "${var.key_name}"
  bastion_ami       = "${lookup(var.aws_ubuntu_amis, var.aws_region)}"
  instance_type     = "t2.micro"
  vpc_id            = "${var.vpc_id}"
  subnet_id         = "${var.public_subnet_id}"
}

module "api" {
    source            = "../module-phoenix"

    environment       = "${var.environment}"
    stack_name        = "${var.stack_name}"
    name_prefix       = "${var.name_prefix}"

    key_pair_id       = "${var.key_name}"
    app_ami           = "${lookup(var.aws_ubuntu_amis, var.aws_region)}"
    vpc_id            = "${var.vpc_id}"
    subnet_id         = "${var.public_subnet_id}"
    elb_sec_grp_id    = "${module.api_elb.sec_grp_id}"
    bastion_ip        = "${module.bastion.public_ip}"
    private_key_path  = "${var.private_key_path}"
    secret_file_path  = "/Users/dehnel/Projects/arsdehnel/recipe-box-api/config/prod.secret.exs"
    db_sec_grp_id     = "${var.db_sec_grp_id}"

    # these are so we can pass them to the CodeDeploy script
    access_key        = "${var.access_key}"
    secret_key        = "${var.secret_key}"
    region            = "${var.aws_region}"

}

module "api_elb" {
  source              = "../module-elb"

  environment         = "${var.environment}"
  stack_name          = "${var.stack_name}"
  name_prefix         = "${var.name_prefix}"

  instance_code       = "api"
  vpc_id              = "${var.vpc_id}"
  subnet_id           = "${var.public_subnet_id}"
  instance_id         = "${module.api.instance_id}"

}

module "app" {
    source            = "../module-app"

    environment       = "${var.environment}"
    stack_name        = "${var.stack_name}"
    name_prefix       = "${var.name_prefix}"

    key_pair_id       = "${var.key_name}"
    app_ami           = "${lookup(var.aws_ubuntu_amis, var.aws_region)}"
    vpc_id            = "${var.vpc_id}"
    subnet_id         = "${var.public_subnet_id}"
    elb_sec_grp_id    = "${module.app_elb.sec_grp_id}"
    bastion_ip        = "${module.bastion.public_ip}"
    private_key_path  = "${var.private_key_path}"

}

module "app_elb" {
  source              = "../module-elb"

  environment         = "${var.environment}"
  stack_name          = "${var.stack_name}"
  name_prefix         = "${var.name_prefix}"

  instance_code       = "app"
  vpc_id              = "${var.vpc_id}"
  subnet_id           = "${var.public_subnet_id}"
  instance_id         = "${module.app.instance_id}"

}

module "deploy_role" {
  source              = "../module-codedeployrole"

  environment         = "${var.environment}"
  stack_name          = "${var.stack_name}"
  name_prefix         = "${var.name_prefix}"

}

module "deploy_api" {
  source              = "../module-codedeploy"

  deploy_code         = "api"
  arn                 = "${module.deploy_role.arn}"
  environment         = "${var.environment}"
  stack_name          = "${var.stack_name}"
  name_prefix         = "${var.name_prefix}"

}
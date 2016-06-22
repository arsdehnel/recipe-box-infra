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

module "db_west2b_subnet" {
  source          = "../module-subnet"

  environment     = "${var.environment}"
  stack_name      = "${var.stack_name}"
  name            = "${var.name_prefix}db"
  az              = "us-west-2b"
  cidr            = "10.0.2.0/24"
  vpc_id          = "${module.vpc.vpc_id}"
  route_table_id  = "${module.vpc.main_route_table_id}"
}
module "db_west2c_subnet" {
  source          = "../module-subnet"

  environment     = "${var.environment}"
  stack_name      = "${var.stack_name}"
  name            = "${var.name_prefix}db"
  az              = "us-west-2c"
  cidr            = "10.0.3.0/24"
  vpc_id          = "${module.vpc.vpc_id}"
  route_table_id  = "${module.vpc.main_route_table_id}"
}


module "db" {
  source            = "../module-rds"

  environment     = "${var.environment}"
  stack_name      = "${var.stack_name}"
  name            = "${var.name_prefix}db"

  subnet_1          = "${module.db_west2b_subnet.id}"
  subnet_2          = "${module.db_west2c_subnet.id}"
}

module "bastion" {
  source            = "../module-bastion"
  
  environment       = "${var.environment}"
  stack_name        = "${var.stack_name}"
  name_prefix       = "${var.name_prefix}"

  key_pair_id       = "${aws_key_pair.keypair.id}"
  bastion_ami       = "${lookup(var.aws_ubuntu_amis, var.aws_region)}"
  instance_type     = "t2.micro"
  vpc_id            = "${module.vpc.vpc_id}"
  subnet_id         = "${module.public_subnet.id}"
}

module "elb" {
  source              = "../module-elb"

  environment         = "${var.environment}"
  stack_name          = "${var.stack_name}"
  name_prefix         = "${var.name_prefix}"

  vpc_id              = "${module.vpc.vpc_id}"
  subnet_id           = "${module.public_subnet.id}"
  instance_id         = "${module.api.instance_id}"

}

module "api" {
    source            = "../module-phoenix"

    environment       = "${var.environment}"
    stack_name        = "${var.stack_name}"
    name_prefix       = "${var.name_prefix}"

    key_pair_id       = "${aws_key_pair.keypair.id}"
    app_ami           = "${lookup(var.aws_ubuntu_amis, var.aws_region)}"
    vpc_id            = "${module.vpc.vpc_id}"
    subnet_id         = "${module.public_subnet.id}"
    elb_sec_grp_id    = "${module.elb.sec_grp_id}"
    bastion_ip        = "${module.bastion.public_ip}"
    private_key_path  = "${var.private_key_path}"
    secret_file_path  = "/Users/dehnel/Projects/arsdehnel/recipe-box-api/config/prod.secret.exs"

    # these are so we can pass them to the CodeDeploy script
    access_key    = "${var.access_key}"
    secret_key    = "${var.secret_key}"
    region        = "${var.aws_region}"

}

module "deploy_role" {
  source            = "../module-codedeployrole"

  environment       = "${var.environment}"
  stack_name        = "${var.stack_name}"
  name_prefix       = "${var.name_prefix}"

}

module "deploy_api" {
  source            = "../module-codedeploy"

  deploy_code       = "api"
  arn               = "${module.deploy_role.arn}"
  environment       = "${var.environment}"
  stack_name        = "${var.stack_name}"
  name_prefix       = "${var.name_prefix}"

}
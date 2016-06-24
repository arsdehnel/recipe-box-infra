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
  name_prefix     = "${var.name_prefix}"
  name            = "${var.name_prefix}db"

  vpc_id          = "${module.vpc.vpc_id}"
  subnet_1          = "${module.db_west2b_subnet.id}"
  subnet_2          = "${module.db_west2c_subnet.id}"
}
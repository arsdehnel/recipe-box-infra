variable "access_key" {}
variable "secret_key" {}
variable "public_key_path" {}
variable "private_key_path" {}
variable "key_name" {}
variable "environment" {}
variable "stack_name" {}
variable "name_prefix" {}

###############################
# from the PERSISTENT setup   #
###############################
variable "vpc_id" {
	default = "vpc-3eddb45a"
}
variable "public_subnet_id" {
	default = "subnet-3bd1b45f"
}
variable "db_endpoint" {
	default = "tf-sbt3uaonbrhpral2d3mxcedony.csbflrjl6b8q.us-west-2.rds.amazonaws.com"
}
variable "db_sec_grp_id" {
	default = "sg-fa30b79c"
}








variable "aws_region" {
    default = "us-west-2"
}

variable "aws_ubuntu_amis" {
    default = {
        us-east-1 = "ami-b8b061d0"
        us-west-2 = "ami-ef5e24df"
    }
}

variable "aws_amazon_amis" {
	default = {
		us-east-1 = "ami-1ecae776"
		us-west-1 = "ami-d114f295"
		us-west-2 = "ami-e7527ed7"
		eu-west-1 = "ami-a10897d6"
		ap-northeast-1 = "ami-cbf90ecb"
		ap-southeast-1 = "ami-68d8e93a"
		ap-southeast-2 = "ami-fd9cecc7"
		sa-east-1 = "ami-b52890a8"
	}
}

variable "aws_codedeploy_bucketname" {
	default = {
		us-east-1 = "aws-codedeploy-us-east-1"
		us-west-1 = "aws-codedeploy-us-west-1"
		us-west-2 = "aws-codedeploy-us-west-2"
		eu-west-1 = "aws-codedeploy-eu-west-1"
		ap-northeast-1 = "aws-codedeploy-ap-northeast-1"
		ap-southeast-1 = "aws-codedeploy-ap-southeast-1"
		ap-southeast-2 = "aws-codedeploy-ap-southeast-2"
		sa-east-1 = "aws-codedeploy-sa-east-1"
	}
}

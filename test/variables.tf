variable "access_key" {}
variable "secret_key" {}
variable "public_key_path" {}
variable "private_key_path" {}
variable "key_name" {}
variable "environment" {}
variable "stack_name" {}
variable "name_prefix" {}

variable "aws_region" {
    default = "us-west-2"
}

variable "aws_linux_amis" {
    default = {
        us-east-1 = "ami-b8b061d0"
        us-west-2 = "ami-ef5e24df"
    }
}
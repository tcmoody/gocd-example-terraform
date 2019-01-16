provider "aws" {
    region = "${var.region}"
    profile = "${var.profile}"
}

module "vpc" {
    source = "./vpc"
    vpc_name = "${var.vpc_name}"
    key_name = "${var.key_name}"
    availability_zone = "${var.availability_zone}"
    provision_key = "${var.provision_key}"
    vpc_cidr = "${var.vpc_cidr}"
    public_subnet_cidr = "${var.public_subnet_cidr}"
    private_subnet_cidr = "${var.private_subnet_cidr}"
}

module "sg" {
    source = "./sg"
    vpc_id = "${module.vpc.vpc_id}"
    vpc_name = "${var.vpc_name}"
}

module "bastion" {
    source = "./bastion"
    vpc_name = "${var.vpc_name}"
    key_name = "${var.key_name}"
    public_subnet_id = "${module.vpc.public_subnet_id}"
    bastion_remote_login_in_id = "${module.sg.bastion_remote_login_in_id}"
    outbound_all_id = "${module.sg.outbound_all_id}"
}

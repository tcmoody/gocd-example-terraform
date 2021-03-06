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
    ami_id = "${var.ami_id}"
    public_subnet_id = "${module.vpc.public_subnet_id}"
    bastion_remote_login_in_id = "${module.sg.bastion_remote_login_in_id}"
    outbound_all_id = "${module.sg.outbound_all_id}"
}

module "server" {
    source = "./server"
    key_name = "${var.key_name}"
    subnet_id = "${module.vpc.private_subnet_id}"
    ami_id = "${var.ami_id}"
    ssh_in_id = "${module.sg.ssh_in_id}"
    outbound_all_id = "${module.sg.outbound_all_id}"
    gocd_server_in_id = "${module.sg.gocd_server_in_id}"
}

module "agent" {
    source = "./agent"
    key_name = "${var.key_name}"
    subnet_id = "${module.vpc.private_subnet_id}"
    ami_id = "${var.ami_id}"
    ssh_in_id = "${module.sg.ssh_in_id}"
    outbound_all_id = "${module.sg.outbound_all_id}"
}

module "lb" {
    source = "./lb"
    server_id = "${module.server.gocd_server_id}"
    subnet_id = "${module.vpc.public_subnet_id}"
    outbound_all_id = "${module.sg.outbound_all_id}"
    elb_inbound_http_id = "${module.sg.elb_inbound_http_id}"
}

module "hosted_zone" {
    source = "./hosted_zone"
    hosted_zone = "${var.hosted_zone}"
    lb-dns-name = "${module.lb.gocd-server-lb-dns-name}"
}
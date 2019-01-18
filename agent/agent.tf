resource "aws_instance" "gocd_agent" {
    ami = "${var.ami_id}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    tags = {
        Name = "gocd-agent"
    }
    vpc_security_group_ids = ["${var.ssh_in_id}", "${var.outbound_all_id}"]
}
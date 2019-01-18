resource "aws_instance" "gocd_server" {
    ami = "${var.ami_id}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    tags = {
        Name = "gocd-server"
    }
}

output "gocd_server_id" {
    value = "${aws_instance.gocd_server.id}"
}
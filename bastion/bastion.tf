resource "aws_instance" "bastion" {
  ami = "ami-01e3b8c3a51e88954"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"

  subnet_id = "${var.public_subnet_id}"
  vpc_security_group_ids = [
    "${var.bastion_remote_login_in_id}",
    "${var.outbound_all_id}"
  ]

  tags {
    Name = "${var.vpc_name}-bastion"
  }
}
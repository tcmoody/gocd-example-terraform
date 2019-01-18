resource "aws_security_group" "bastion-remote-login-in" {
  name        = "${var.vpc_name}-bastion-remote-login-in"
  description = "Allow inbound traffic for remote login"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "outbound-all" {
  name        = "${var.vpc_name}-outbound-all"
  description = "Allow all outbound traffic"
  vpc_id = "${var.vpc_id}"
  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh-in" {
  name = "${var.vpc_name}-ssh-in"
  description = "Allow for ssh for remote login"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "gocd_server_in" {
  name = "${var.vpc_name}-gocd-server-in"
  description = "Allow http traffic to gocd_server"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port       = "8153"
    to_port         = "8154"
    protocol        = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Outputs
output "bastion_remote_login_in_id" {
  value = "${aws_security_group.bastion-remote-login-in.id}"
}

output "outbound_all_id" {
  value = "${aws_security_group.outbound-all.id}"
}

output "ssh_in_id" {
  value = "${aws_security_group.ssh-in.id}"
}

output "gocd_server_in_id" {
  value = "${aws_security_group.gocd_server_in.id}"
}
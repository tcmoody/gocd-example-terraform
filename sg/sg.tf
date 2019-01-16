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

// Outputs
output "bastion_remote_login_in_id" {
  value = "${aws_security_group.bastion-remote-login-in.id}"
}

output "outbound_all_id" {
  value = "${aws_security_group.outbound-all.id}"
}
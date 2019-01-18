resource "aws_elb" "gocd-server-lb" {
    name = "gocd-server-lb"
    subnets = ["${var.subnet_id}"]
    listener {
        instance_port     = 8153
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "TCP:8153"
        interval            = 30
    }

    instances                   = ["${var.server_id}"]
    cross_zone_load_balancing   = true
    idle_timeout                = 400
    connection_draining         = true
    connection_draining_timeout = 400

    tags = {
        Name = "gocd-server-elb"
    }
}

output "gocd-server-lb-dns-name" {
    value = "${aws_elb.gocd-server-lb.dns_name}"
}


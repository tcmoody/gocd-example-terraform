resource "aws_elb" "gocd-server-lb" {
    name = "gocd-server-lb"
    // availability_zones = ["us-east-1a", "us-east-1b"]
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
        target              = "HTTP:8153/"
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
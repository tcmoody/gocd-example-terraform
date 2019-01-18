resource "aws_route53_zone" "primary" {
  name = "${var.hosted_zone}.com"
}

resource "aws_route53_record" "gocd-server-lb-record" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "gocd.${var.hosted_zone}.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.lb-dns-name}"]
}
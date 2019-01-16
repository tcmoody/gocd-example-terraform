data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_key_pair" "provisioner_key" {
  key_name   = "${var.key_name}"
  public_key = "${var.provision_key}"
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.vpc_name}"
  }
}

// Public Subnet: begin
resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "${var.availability_zone}"

  tags {
    Name = "${var.vpc_name}-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route" "igw-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "vpc_nat_eip" {
  vpc = true
  depends_on = ["aws_vpc.vpc"]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.vpc_nat_eip.id}"
  subnet_id = "${aws_subnet.public.id}"
}
// Public Subnet: end

// Private Subnet: begin
resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "${aws_subnet.public.availability_zone}"

  tags {
    Name = "${var.vpc_name}-private-subnet"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_route" "nat-route" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "private" {
  subnet_id = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}
// Private Subnet: end

// Outputs: start
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public.id}"
}

output "private_subnet_id" {
  value = "${aws_subnet.private.id}"
}
// Outputs: end
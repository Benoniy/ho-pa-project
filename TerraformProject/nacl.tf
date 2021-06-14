resource "aws_network_acl" "allowall" {
	vpc_id = aws_vpc.main.id

	egress{
	protocol = "-1"
	rule_no = 100
	action = "allow"
	cidr_block = "0.0.0.0/0"
	from_port = 0
	to_port = 0
	}

	ingress {
	protocol = "-1"
	rule_no = 200
	action = "allow"
	cidr_block = "0.0.0.0/0"
	from_port = 0
	to_port = 0
	}
}
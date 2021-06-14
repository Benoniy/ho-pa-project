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
resource "aws_security_group" "main" {
    name = "ho_k8_sec_group"
    description = "Control traffic for all worker and master nodes"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port  = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["69.69.0.0/24"]
    }  

    ingress {
        from_port  = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["69.69.0.0/24"]
    }

    ingress {
        from_port  = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["69.69.0.0/16"]
    }

    ingress {
        from_port  = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["69.69.0.0/16"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ho_k8_sec_group"
    }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

    
  tags = {
      Name = "ho_k8_default_sec_group"
  }
}
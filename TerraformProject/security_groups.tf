resource "aws_security_group" "main" {
    name = "ho_k8_sec_group"
    description = "Control traffic for all worker and master nodes"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port  = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["217.155.15.136/32"]
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
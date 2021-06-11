resource "aws_security_group" "main" {
    name = "security_port_ho_project"
    description = "Allow inbound traffic"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port  = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port  = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port  = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ho_project_security_port"
    }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

    
  tags = {
      Name = "ho_default_security_group"
  }
}
resource "aws_instance" "firstInstance" {
    ami = "ami-015e12b7e80c0bf5d"
    key_name = "ho-pa-project"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_1.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.main.id]
    tags = {
        Name = "ho_first_instace"
    }
}

resource "aws_instance" "secoundInstance" {
    ami = "ami-015e12b7e80c0bf5d"
    key_name = "ho-pa-project"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_2.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.main.id]
    tags = {
        Name = "ho_secound_instace"
    }
}

resource "aws_instance" "privateInstance" {
    ami = "ami-0943382e114f188e8"
    key_name = "ho-pa-project"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_1a.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.main.id]
    tags = {
        Name = "ho_private_instace"
    }
}


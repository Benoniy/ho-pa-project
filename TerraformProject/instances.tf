resource "aws_instance" "privateInstance" {
    ami = "ami-0308a1cade9976b8e"
    key_name = "ho-pa-project"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_1a.id
    associate_public_ip_address = true
    private_ip = "69.69.69.194"
    vpc_security_group_ids = [aws_security_group.main.id]

    tags = {
        Name = "ho_k8_master"
    }
}

resource "aws_instance" "firstInstance" {
    ami = "ami-015e12b7e80c0bf5d"
    key_name = "ho-pa-project"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_1.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.main.id]

    tags = {
        Name = "ho_k8_worker_1"
    }

    depends_on = [aws_instance.privateInstance]
}

resource "aws_instance" "secondInstance" {
    ami = "ami-015e12b7e80c0bf5d"
    key_name = "ho-pa-project"
    instance_type = "t2.micro"
    
    subnet_id = aws_subnet.public_2.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.main.id]

    tags = {
        Name = "ho_k8_worker_2"
    }

    depends_on = [aws_instance.privateInstance]
}

resource "local_file" "master_ids" {
    content  = aws_instance.privateInstance.id
    filename = "/home/ubuntu/terraFiles/master_ids"
}

resource "local_file" "worker_ids" {
    content  = "${aws_instance.firstInstance.id}\n${aws_instance.secondInstance.id}"
    filename = "/home/ubuntu/terraFiles/worker_ids"
}

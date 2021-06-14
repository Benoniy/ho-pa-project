resource "aws_instance" "firstInstance" {
    ami = "ami-015e12b7e80c0bf5d"
    key_name = "ho-pa-project"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_1.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.main.id]

    provisioner "remote-exec" {
        inline = [
          "sudo kubeadm join 69.69.69.194:6443 --token 26t0sl.taobbhyry60ulthi --discovery-token-ca-cert-hash sha256:1ed312efc9f6b62c9c94c56d086a259f989bddd54f337937cfd60f5a8850e35a",
        ]
    }

    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("~/.ssh/ho-pa-project.pem")
        host        = self.public_ip
        agent       = false
    }

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

resource "aws_instance" "privateInstance" {
    ami = "ami-0308a1cade9976b8e"
    key_name = "ho-pa-project"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_1a.id
    associate_public_ip_address = true
    private_ip = "69.69.69.194"
    vpc_security_group_ids = [aws_security_group.main.id]
    
    provisioner "remote-exec" {
        inline = [
          "sudo kubeadm init --pod-network-cidr=69.69.0.0/16 --ignore-preflight-errors=all",
        ]
    }

    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("~/.ssh/ho-pa-project.pem")
        host        = self.public_ip
        agent       = false
    }

    tags = {
        Name = "ho_k8_master"
    }
}


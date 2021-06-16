resource "aws_instance" "firstInstance" {
    ami = "ami-015e12b7e80c0bf5d"
    key_name = "ho-pa-project"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_1.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.main.id]

    provisioner "file" {
        source      = "~/tmp/joincmd.sh"
        destination = "/home/ubuntu/join.sh"
    }

    provisioner "remote-exec" {
        on_failure = continue
        inline = [
        "sudo chmod +x ~/join.sh",
        "sudo reboot now"
        ]
    }

    provisioner "local-exec" {
        command = "Start-Sleep -Seconds 60"
        interpreter = ["PowerShell", "-Command"]
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
    
    provisioner "file" {
        source      = "~/tmp/joincmd.sh"
        destination = "/home/ubuntu/join.sh"
    }

    provisioner "remote-exec" {
        on_failure = continue
        inline = [
            "sudo chmod +x ~/join.sh", 
            "sudo reboot now"
        ]
    }

    provisioner "local-exec" {
        command = "Start-Sleep -Seconds 60"
        interpreter = ["PowerShell", "-Command"]
    }

    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("~/.ssh/ho-pa-project.pem")
        host        = self.public_ip
        agent       = false
    }

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
            "echo -n \"sudo \" > joincommand.sh && kubeadm token create --print-join-command >> joincommand.sh",
            "sudo chmod +x joincommand.sh",
            "echo -n 'nameserver 1.1.1.1' | sudo tee -a /etc/resolv.conf"
        ]
    }

    provisioner "local-exec" {
        command = "scp -i ~/.ssh/ho-pa-project.pem -o StrictHostKeyChecking=no ubuntu@${self.public_ip}:~/joincommand.sh ~/tmp/joincmd.sh"
        interpreter = ["PowerShell", "-Command"]
    }

    provisioner "remote-exec" {
        on_failure = continue
        inline = [
            "sudo reboot now",
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

resource "null_resource" "provision_rs1"{

    provisioner "remote-exec" {
        inline = [
            "bash ~/join.sh",
        ]
    }

    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("~/.ssh/ho-pa-project.pem")
        host        = aws_instance.firstInstance.public_ip
        agent       = false
    }

    depends_on = [aws_instance.privateInstance, aws_instance.firstInstance, aws_instance.secondInstance]
}

resource "null_resource" "provision_rs2"{

    provisioner "remote-exec" {
        inline = [
            "bash ~/join.sh",
        ]
    }

    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("~/.ssh/ho-pa-project.pem")
        host        = aws_instance.secondInstance.public_ip
        agent       = false
    }

    depends_on = [aws_instance.privateInstance, aws_instance.firstInstance, aws_instance.secondInstance]
}

resource "null_resource" "provision_k8"{
    
    provisioner "file" {
        source      = "../Kubernetes/create_deployment.yml"
        destination = "/home/ubuntu/create_deployment.yml"
    }

    provisioner "remote-exec" {
        inline = [
            "kubectl apply -f create_deployment.yml",
        ]
    }

    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("~/.ssh/ho-pa-project.pem")
        host        = aws_instance.privateInstance.public_ip
        agent       = false
    }

    depends_on = [null_resource.provision_rs2, null_resource.provision_rs1]
}


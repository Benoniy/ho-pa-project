resource "aws_vpc" "main" {
    cidr_block = "69.69.0.0/16" #69.69.0.0/16

    # Make your instances shared on the host.

    instance_tenancy = "default"

    tags = {
      Name = "ho_project_main"
    }
}

output "vpc_id" {
    value = aws_vpc.main.id
    description = "VPC id"
    sensitive = false
}
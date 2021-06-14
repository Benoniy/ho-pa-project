resource "aws_subnet" "public_1" {

    vpc_id = aws_vpc.main.id

    cidr_block = "69.69.60.0/24"

    availability_zone = "eu-west-1a"

    #Instances launched into subnet should be assinged a public IP address

    map_public_ip_on_launch = true

    tags = {
      Name = "ho_k8_public_subnet_eu-west-1a"
    }
}

resource "aws_subnet" "public_2" {

    vpc_id = aws_vpc.main.id

    cidr_block = "69.69.64.0/24"

    availability_zone = "eu-west-1b"

    #Instances launched into subnet should be assinged a public IP address

    map_public_ip_on_launch = true

    tags = {
      Name = "ho_k8_public_subnet_eu-west-1b"
    }
}

resource "aws_subnet" "private_1a" {

    vpc_id = aws_vpc.main.id

    cidr_block = "69.69.69.0/24"

    availability_zone = "eu-west-1a"

    tags = {
      Name = "ho_k8_private_subnet_eu-west-1a"
    }
}
  

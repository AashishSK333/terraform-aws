provider "aws" {
  region = "ap-southeast-1"
}
# 1. Creating a Custom VPC
resource "aws_vpc" "zta-vpc" {
  cidr_block = "10.0.0.0/16"
}
# 2. Creating a Internet Gateway
resource "aws_internet_gateway" "zta-gw" {
  vpc_id = aws_vpc.zta-vpc.id
  
}
# 3. Creating a subnet under the ZTA Route table and allow all internet traffic
resource "aws_route_table" "zta-route-table" {
  vpc_id = aws_vpc.zta-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zta-gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.zta-gw.id
  }

  tags = {
    Name = "zta-prod-route-table"
  }
}
# 4. Creating 2 subnets under the ZTA VPC in different AZ's
resource "aws_subnet" "zta-subnet-1" {
  vpc_id = aws_vpc.zta-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "zta-subnet-az-1a"
  }
}

resource "aws_subnet" "zta-subnet-2" {
  vpc_id = aws_vpc.zta-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "zta-subnet-az-1b"
  }
}

# 5. Associate subnets with Route table 
resource "aws_route_table_association" "zta-subnet-association-1a" {
  subnet_id      = aws_subnet.zta-subnet-1.id
  route_table_id = aws_route_table.zta-route-table.id
}

resource "aws_route_table_association" "zta-subnet-association-1b" {
  subnet_id      = aws_subnet.zta-subnet-2.id
  route_table_id = aws_route_table.zta-route-table.id
}

# 6. Create Security Group to allow 22, 80, 443
resource "aws_security_group" "zta-allow-web-traffic" {
  name = "allow-web-traffic"
  description = "Allow web inbound traffic"
  vpc_id = aws_vpc.zta-vpc.id

  ingress {
    description = "all https traffic"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
  ingress {
    description = "all http traffic"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "SSH traffic from all internet"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" #any protocol
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "allow_tls_from_web"
  }
}

# 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "zta-web-server-nic" {
  subnet_id = aws_subnet.zta-subnet-1.id
  private_ips = ["10.0.1.50"]
  security_groups = [aws_security_group.zta-allow-web-traffic.id]

}

# 8. Assign an elastic ip to the network interface created in step 7
resource "aws_eip" "zta-eip" {
  #vpc = true
  network_interface =   aws_network_interface.zta-web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  # Creation of elastic ip address depends on internet gateway
  depends_on = [ aws_internet_gateway.zta-gw ]
}

# 9. Create Ubantu server & install apache 2
resource "aws_instance" "zta-Ubantu-instance" {
  ami = "ami-06c4be2792f419b7b"
  instance_type = "t3.micro"
  availability_zone = "ap-southeast-1a"
  key_name = "zeta-key"
  
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.zta-web-server-nic.id
  }    

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo Zero Trust Architecture Web Server > /var/www/html/index.html'
              EOF
  tags = {
    Name = "ZTA Web Server"
  }
}
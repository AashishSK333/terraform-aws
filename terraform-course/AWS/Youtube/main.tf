#https://www.youtube.com/watch?v=SLB_c_ayRMo

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }    
  }
}

provider "aws" {
    region = "ap-southeast-1"  
}

resource "aws_vpc" "test-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "production"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
}
/*
resource "aws_instance" "web-app" {
  ami           = "ami-06c4be2792f419b7b"
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
  
}*/
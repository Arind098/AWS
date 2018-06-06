provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "ap-south-1"
}

resource "aws_instance" "assessment" {
  ami           = "ami-3c0e7353"
  instance_type = "t2.micro"
  key_name = "trial"
  user_data = "${file("user-dat.txt")}"
}

resource "aws_security_group" "access-http" {
  name = "access-http"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh" {
  name = "ssh"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

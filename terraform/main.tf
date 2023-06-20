resource "aws_instance" "my_instance" {
  ami           = "ami-08766f81ab52792ce"
  instance_type = "t3.micro"

  key_name      = "nginx-ssh"
  user_data     = file("startup_script.sh")


  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "exchange-currency"
  }
}


resource "aws_security_group" "my_security_group" {
  name        = "exchange-security-group"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "exchange-security-group"
  }
}
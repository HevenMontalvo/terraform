/* Any comment here */

provider "aws" {
  region = "us-east-1"
}

# This is a single-line comment.

resource "aws_instance" "base" {
  ami                    = "ami-0d729a60"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello my little world" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "example-3"
  }
}

resource "aws_security_group" "sg_instance" {
  name = "terraform-sg-istance-example"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

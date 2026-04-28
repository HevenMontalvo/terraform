terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


# SSH key

resource "aws_key_pair" "instance" {
  key_name   = "instance"
  public_key = file("~/sshkeys/my-aws-key.pub")
}

# EC2 Instance
resource "aws_instance" "example" {
  ami                    = "ami-0ec10929233384c7f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.instance.key_name

  user_data = <<-EOF
              #!/bin/bash
              
              # Install Apache (In Ubuntu the package is apache2)
              apt-get install -y apache2

              # Change port from 80 to 8080
              # Ubuntu stores config in /etc/apache2/ports.conf
              sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
              
              # Also update the default VirtualHost to listen on 8080
              sed -i 's/:80/:8080/' /etc/apache2/sites-available/000-default.conf

              # Start and enable service
              systemctl restart apache2
              systemctl enable apache2

              # Create basic index file
              echo "<h1>Connected successfully to Ubuntu on port 8080</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  # Aapache rules
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # install packages
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH rules

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["189.219.188.141/32"]
  }
}

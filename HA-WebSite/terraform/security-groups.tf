# security group creation and attcahing

# WebServer Security Group:
resource "aws_security_group" "web-servers" {
  name        = "WebServer Security Group"
  description = "Dynamic Web Security Group"
  vpc_id      = aws_vpc.wave-vpc.id

  dynamic ingress {
    for_each = ["80", "443", "21", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      #cidr_blocks = ["${aws_vpc.wave-vpc.cidr_block}"]
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    #cidr_blocks = ["${aws_vpc.wave-vpc.cidr_block}"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web-SG"
    Owner = "Alex Largman"
  }
}

# Bastion Security Group:
resource "aws_security_group" "BastionServer" {
  name        = "BastionServer Security Group"
  description = "Dynamic BastionServer Security Group"
  vpc_id      = aws_vpc.wave-vpc.id

  dynamic ingress {
    for_each = ["80", "443", "21", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      #cidr_blocks = ["${aws_vpc.wave-vpc.cidr_block}"]
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    #cidr_blocks = ["${aws_vpc.wave-vpc.cidr_block}"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #cidr_blocks = ["${aws_vpc.wave-vpc.cidr_block}"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "BastionServer-sg"
    Owner = "Alex Largman"
  }
}

# LB Security Group:
resource "aws_security_group" "lb-sg" {
  name        = "LB Security Group"
  description = "Dynamic LB Security Group"
  vpc_id      = aws_vpc.wave-vpc.id

  dynamic ingress {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LB-SG"
    Owner = "Alex Largman"
  }
}

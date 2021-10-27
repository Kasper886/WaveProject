# Find the latest amazon ubuntu image
data "aws_ami" "latest_amazon_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_configuration" "web" {
  name_prefix                 = "WebServer-Highly-Available-LC-"
  image_id                    = data.aws_ami.latest_amazon_ubuntu.id
  instance_type               = var.instance_type
  spot_price                  = var.spotprice
  key_name                    = aws_key_pair.private-node.key_name 
  security_groups             = [aws_security_group.web-servers.id]
  associate_public_ip_address = false
    
  lifecycle {
    create_before_destroy = true
  }
}

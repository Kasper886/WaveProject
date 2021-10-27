resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  key_name                    = aws_key_pair.public-node.key_name
  security_groups             = [aws_security_group.BastionServer.id]
  associate_public_ip_address = true
  depends_on                  = [aws_nat_gateway.wave-natgw]
  
  #Attach IAM role
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name


  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Bastion Host"
  }


# Copy private key of private nodes for ansible access. 
  provisioner "file" {
    source      = var.ssh-private-node["PATH_TO_PRIVATE_KEY"]
    destination = "/home/ubuntu/.ssh/private-node"
  }

  # Copy ansible's folder for servers configuration.
  provisioner "file" {
    source      = "../ansible"
    destination = "/home/ubuntu/"
  }

  # Copy docker's folder for ansible use. 
  provisioner "file" {
    source      = "../docker"
    destination = "/home/ubuntu/"
  }

  # Execute commands on public node.
  provisioner "remote-exec" {
    inline = [
      "chmod 0400 /home/ubuntu/.ssh/private-node",
      "sudo apt-get update -y",
      "sudo apt-get install python3 -y",
      "sudo apt-get install python3-pip -y",
      "sudo pip3 install boto3",
      "sudo apt-get install ansible -y",
      "mkdir /home/ubuntu/www",
      "mkdir /home/ubuntu/www/html",
      "cd ~/ansible",
      
      # Create inventory file and [all] nodes group 
      "touch inventory",
      "echo '[all]' > inventory",

      # Get node's IPs and put to inventory file by means of aws ec2 plugin
      "ansible-inventory -i aws_ec2.yaml --graph  > temp.txt",
      "sed '1,2d; $d; s/  |  |--ip-//; s/.ec2.internal//; s/-/./g' temp.txt >> inventory",
      
      "ansible-playbook apache.yml -i inventory",
    ]
  }

  # Connect for remote execute
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.users["ubuntu"]
    private_key = file(var.ssh-public-node["PATH_TO_PRIVATE_KEY"])
  }
}
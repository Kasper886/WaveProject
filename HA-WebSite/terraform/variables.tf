variable "aws_region" {
  default     = "us-east-1"
  description = "aws region where our resources are going to create choose"
  #replace the region as suits for your requirement
}

variable "aws_vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "az_count" {
  default     = "2"
  description = "number of availability zones in above region"
}

variable "azs" {
    type = list
    default = ["1a", "1b"]
}

variable "app_port" {
  default     = "80"
  description = "portexposed on the docker image"
}

variable "app_count" {
  default     = "2" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

#EC2 Properties
variable "spotprice" {
  default = "0.20"
}

variable "spot_type" {
  default = "persistent"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-09e67e426f25ce0d7"
}
#End EC2 Properties

#SSH key. You should generate key-pair in AWS account and put your keys in the folder.
variable "awskeypair" {
  default = "Virginia"
}

variable "ssh-public-node" {
  type = map(string)
  default = {
    "PATH_TO_PRIVATE_KEY" = "~/.ssh/id_rsa/public-node"
    "PATH_TO_PUBLIC_KEY" = "~/.ssh/id_rsa/public-node.pub"
  }
}

variable "ssh-private-node" {
  type = map(string)
  default = {
    "PATH_TO_PRIVATE_KEY" = "~/.ssh/id_rsa/private-node"
    "PATH_TO_PUBLIC_KEY" = "~/.ssh/id_rsa/private-node.pub"
  }
}

variable "users" {
  type = map(string)
  default = {
    "ubuntu" = "ubuntu"
  }
}
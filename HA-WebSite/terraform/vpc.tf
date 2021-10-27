# network.tf

resource "aws_vpc" "wave-vpc" {
  cidr_block = var.aws_vpc_cidr
  tags            = {
    Name          = "wave-vpc"
  }
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}


# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.wave-vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.wave-vpc.id

  tags = {
    Name   = "PrivateSubnet-${count.index+1}"
    Owner  = "Alex Largman"
  }
}

# Create public subnet
resource "aws_subnet" "public" {
  cidr_block              = "10.10.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  vpc_id                  = aws_vpc.wave-vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubNet"
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "wave-igw" {
  vpc_id = aws_vpc.wave-vpc.id

   tags = {
     Name = "WaveGW"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.wave-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wave-igw.id
}

# Associate the public subnet traffic and close private subnets traffic
resource "aws_route_table_association" "public-a" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_vpc.wave-vpc.main_route_table_id
}


# Private networks A and B with NAT GW to enable to install soft
# You can delete the NGW and route tables after settings

# Allocate 2 Elastic IPs for 2 NGW
resource "aws_eip" "wave-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.wave-igw]
  
  tags = {
    Name     = "Wave-EIP"
  }
}

# Ceate the Nat GW
resource "aws_nat_gateway" "wave-natgw" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.wave-eip.id

  tags = {
    Name        = "Wave-NGW"
  }
}


# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.wave-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wave-natgw.id
  }

  tags = {
    Name          = "WaveNGW-RTBL"
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
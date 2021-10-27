# key for public node
resource "aws_key_pair" "public-node" {
  key_name   = "public-node"
  public_key = file(var.ssh-public-node["PATH_TO_PUBLIC_KEY"])
}

# key for private nodes
resource "aws_key_pair" "private-node" {
  key_name   = "private-node"
  public_key = file(var.ssh-private-node["PATH_TO_PUBLIC_KEY"])
}
# AWS EKS cluster creation by Terraform
Thie repo demonstrates how to create AWS EKS cluster by means of IaaC Terraform and assign network resources to it. Below you can find the diagram that illustrates created cluster.

![Image alt](https://github.com/Kasper886/WaveProject/blob/master/EKS-Cluster/files/diagram.png)

## Summary
### Network
1. Dedicated VPC
2. 2 public subnets in 2 availability zones A and B
3. 2 private subnets in 2 availability zones A and B
4. Internet gateway for Future use
5. NAT gateway to get access for private instances for Future use
6. Route Tables
7. Route Table Association

### Nodes
1. Worker nodes in private subnets
2. Scaling configuration - desired size = 2, max size = 10, min_size = 1
3. Instances type - spot instances t3.small

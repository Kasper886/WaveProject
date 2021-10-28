# Highly Available Web Site

This repository allows to create a highly available web site. By running this script you will receive 2 private subnets in 2 availability zones (AZ) - A and B and one public subnet in AZ A. 2 web servers works in AZ A and B and controlled by AWS application load balancer (ALB). The cluster can be reached through ALB dns name that you can see in the end of the process in your concole.

Below you can see the diagram of the system.

![Image alt](https://github.com/Kasper886/WaveProject/blob/master/HA-WebSite/files/HA_WebSite.png)

## Principle of operation
For this project Terraform, Ansible and AWS bundle was used. IaaC creates the environment, that consists of 2 web servers in 2 AZ and bastion host with Ansible. The process is automated, because AWS EC2 plugin to create Ansible inventory file is used. So you don't need to start the Ansible playbook then.

## How to do

### 1. Export AWS credentials and your default region (I worked in us-east-1 region)
```
export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxx
export AWS_DEFAULT_REGION=us-east-1
```
### 2. Generate 2 ssh key pairs with names private-node and public-node
```
ssh-keygen
```
### 3. Clone repository and start the Terraform script
```
git clone https://github.com/Kasper886/WaveProject.git
```
```
cd WaveProject/HA-WebSite/terraform/
```
```
terraform init
```
```
terraform plan
```
```
terraform apply -auto-approve
```
(You need terraform installed)
### 4. When done, go to AWS account -> VPC -> route tables and de-associate subnets from WaveNGW-RTBL
### 5. When you finish delete your resources
```
terraform destroy -auto-approve
```
## Demo
(https://github.com/Kasper886/WaveProject/blob/master/HA-WebSite/files/DemoVideo.mp4)

# AWS EKS application deployment
This repo is Jenkins pipeline example of deploying application from Github to AWS EKS cluster with AWS ECR image. We will use this [application](https://github.com/Kasper886/guest-book). The application consists of a web front end, Redis master for storage, and replicated set of Redis slaves, all for which we will create Kubernetes replication controllers, pods, and services.

## Pre Requirements
To work with this repo you need started EKS cluster. If you did't it before, go to this [section](https://github.com/Kasper886/WaveProject/tree/master/EKS-Cluster) and follow instructions there.

1. Let's create ECR Repository by Terraform:
```
cd App
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
If you created EKS cluster from previous section you already have Terraform and applied AWS credentials before.

2. Install Jenkins and necessary plugins
You can read how install Jenkins from the official documentation [here](https://www.jenkins.io/doc/book/installing/linux/).
Also you need the next plugins:
- CloudBees AWS credentials
- Kubernetes Continuous Deploy
- Docker
- Docker Pipeline!

![plugins](https://user-images.githubusercontent.com/51818001/141674103-1117057c-8c71-4de4-98d0-18a63c5ad179.png)

3. Credentials settings.
Go to Jenkins -> Manage Jenkins -> Global credentials section and add AWS credentials with ID ecr

![ECR-cred](https://user-images.githubusercontent.com/51818001/141673986-8f615e47-3bf5-4748-9466-5f669bf4e481.png)

Then input the following command to get EKS config if you didn't it before in previous section:
```
aws eks update-kubeconfig --name eks --region us-east-1
```
and
```
cat /home/wave/.kube/config
```
Copy result of this command and return to Jenkins credentials section, then create Kubernetes credentials and choose Kubeconfig Enter directly

![EKS-cred](https://user-images.githubusercontent.com/51818001/141674297-d0678fe6-1622-4044-9cfb-e68cb84dd45a.png)




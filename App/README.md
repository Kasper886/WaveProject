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

2. Install Java
```
sudo apt -y install openjdk-11-jdk
```

3. Install Docker if you don't have it:
```
chmod +x docker.sh
./docker.sh
```
To use Docker without sudo, run:
```
sudo usermod -aG docker ${USER}
su - ${USER}
```

4. Install Jenkins and necessary plugins
You can read how install [Jenkins on Linux](https://www.jenkins.io/doc/book/installing/linux/).
Or you can start Jenkins with Docker container:
```
mkdir ~/jenkins
docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v ~/jenkins:/var/jenkins_home jenkins/jenkins:lts-jdk11
```
Also you need the next plugins:
- CloudBees AWS credentials;
- Kubernetes Continuous Deploy (v.1.0.0), you can download [this file](https://updates.jenkins.io/download/plugins/kubernetes-cd/1.0.0/kubernetes-cd.hpi) and upload it in advanced settings in Jenkins plugin management section;
- Docker;
- Docker Pipeline;
- Amazon ECR plugin.

![plugins3](https://user-images.githubusercontent.com/51818001/142757989-6ffa7c12-98c3-4562-b3fa-962acd39ece6.png)

5. Credentials settings.
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

And input ID K8S (IMPORTANT! Field id K8S should contain all upper-case)

Also, run to get access for Jenkins to your EKS cluster
```
kubectl create clusterrolebinding cluster-system-anonymous --clusterrole=cluster-admin --user=system:anonymous
```

6. Make sure you create Maven3 variable under Global tool configuration.

![maven3](https://user-images.githubusercontent.com/51818001/141674371-a22998f4-0c63-4b0e-b928-9e581c30f14f.png)

7. Create new pipeline in Jenkins and copy Jenkinsfile there.

Build your pipeline.

8. Run the following command to get access from your browser:
```
kubectl get svc
```
Then copy the dns name of the load balancer. It should be something like this:
a50fec56374e843a6afbf0f96488e800-1553267577.us-east-1.elb.amazonaws.com
and add port 3000
http://a50fec56374e843a6afbf0f96488e800-1553267577.us-east-1.elb.amazonaws.com:3000

http in url is required 

9. To delete the services and deployments without cluster destroying run:
```
git clone https://github.com/Kasper886/guest-book.git
cd guest-book
```
```
kubectl delete -f redis-master-controller.yaml
kubectl delete -f redis-slave-controller.yaml
kubectl delete -f guestbook-controller.yaml
```
```
kubectl delete service guestbook redis-master redis-slave
```
10. To destroy EKS cluster
Destroy ECR repo
```
terraform destroy -auto-approve
```
Destroy EKS cluster
```
cd ..
terraform destroy -auto-approve
```

## Demo


https://user-images.githubusercontent.com/51818001/142759135-cbc61a86-0b47-4d56-8394-f1b3737389b5.mp4

![screen1](https://user-images.githubusercontent.com/51818001/141676063-6bab5a63-558c-4968-9440-7f3072184b88.png)

![ECR-image](https://user-images.githubusercontent.com/51818001/141675918-eabf9fec-90fa-4225-a829-bb447a116e6b.png)

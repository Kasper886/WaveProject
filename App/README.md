# AWS EKS application deployment
This repo is Jenkins pipeline example of deploying application from Github to AWS EKS cluster with AWS ECR image. We will use this [application](https://github.com/Kasper886/guest-book). The application consists of a web front end, Redis master for storage, and replicated set of Redis slaves, all for which we will create Kubernetes replication controllers, pods, and services.

To work with this repo you need started EKS cluster. If you did't it before, go to this [section](https://github.com/Kasper886/WaveProject/tree/master/EKS-Cluster) and follow instructions there.

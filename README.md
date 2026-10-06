# aws-eks-devops-project
AWS EKS project  
# 🚀 Production-Style AWS Kubernetes CI/CD Platform

A production-style DevOps project that demonstrates automated application deployment on Amazon EKS using Jenkins, Docker, Amazon ECR, Kubernetes, Helm, Terraform, and AWS networking.

The project is designed to simulate a real-world cloud-native deployment workflow where infrastructure is provisioned using Infrastructure as Code and application deployments are automated through a CI/CD pipeline.

---

## 🏗️ Architecture

```text
                         Developer
                             |
                             | git push
                             v
                        +---------+
                        | GitHub  |
                        +----+----+
                             |
                          Webhook
                             |
                             v
                       +-----------+
                       |  Jenkins  |
                       +-----+-----+
                             |
                    +--------+--------+
                    |                 |
               Docker Build      Security Scan
                    |                 |
                    +--------+--------+
                             |
                             v
                       +-----------+
                       | Amazon ECR|
                       +-----+-----+
                             |
                             v
                     +---------------+
                     |  Amazon EKS   |
                     |               |
                     |  Kubernetes   |
                     |    Pods       |
                     +-------+-------+
                             |
                         Kubernetes
                           Service
                             |
                             v
                    +----------------+
                    | AWS Load       |
                    | Balancer /     |
                    | Ingress        |
                    +-------+--------+
                            |
                            v
                          Users


              +-------------------------+
              |       Terraform         |
              |                         |
              | VPC                     |
              | Subnets                 |
              | IAM                     |
              | EKS                    |
              | Node Groups             |
              | Networking              |
              +-------------------------+
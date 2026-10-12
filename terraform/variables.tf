
variable "aws_region" {
  description = "AWS region for the DevOps project"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix for project resources"
  type        = string
  default     = "cloudops"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "cloudops-eks"
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default = "1.36"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_nodes" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}


pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        AWS_REGION       = 'ap-south-1'
        AWS_ACCOUNT_ID   = '933367720819'
        ECR_REPOSITORY   = 'cloudops-app'
        IMAGE_NAME       = 'cloudops-app'
        IMAGE_TAG        = "${BUILD_NUMBER}"
        ECR_REGISTRY     = '933367720819.dkr.ecr.ap-south-1.amazonaws.com'
        EKS_CLUSTER_NAME = 'cloudops-eks'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Files') {
            steps {
                sh '''
                    set -eu
                    test -f app/index.html
                    test -f Dockerfile
                    test -f K8s/deployment.yaml
                    test -f K8s/service.yaml
                    echo "All required files found"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    set -eu
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker image inspect ${IMAGE_NAME}:${IMAGE_TAG} >/dev/null
                '''
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh '''
                    set -eu
                    aws ecr get-login-password --region ${AWS_REGION} |
                    docker login --username AWS --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                    set -eu
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} \
                      ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}

                    docker push \
                      ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                '''
            }
        }

        stage('Configure EKS Access') {
            steps {
                sh '''
                    set -eu
                    aws eks update-kubeconfig \
                      --region ${AWS_REGION} \
                      --name ${EKS_CLUSTER_NAME}

                    kubectl get deployment cloudops-app
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    set -eu

                    sed "s|IMAGE_PLACEHOLDER|${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}|g" \
                      K8s/deployment.yaml | kubectl apply -f -

                    kubectl apply -f K8s/service.yaml

                    kubectl rollout status deployment/cloudops-app \
                      --timeout=180s
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    set -eu
                    kubectl get deployment cloudops-app
                    kubectl get pods -o wide
                    kubectl get service cloudops-app-service
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD succeeded: image pushed to ECR and deployed to EKS.'
        }
        failure {
            echo 'Pipeline failed. Check the stage logs.'
        }
    }
}

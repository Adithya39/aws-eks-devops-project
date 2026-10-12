
pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '933367720819'
        ECR_REPOSITORY = 'cloudops-app'
        IMAGE_NAME = 'cloudops-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
        ECR_REGISTRY = '933367720819.dkr.ecr.ap-south-1.amazonaws.com'
        EKS_CLUSTER_NAME = 'cloudops-eks'
    }

    stages {
        stage('Checkout the code1') {
            steps {
                checkout scm
            }
        }

        stage('Validate Files') {
            steps {
                sh '''
                    test -f app/index.html
                    test -f Dockerfile
                    echo "Application and Dockerfile found"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Verify Image') {
            steps {
                sh '''
                    docker image inspect ${IMAGE_NAME}:${IMAGE_TAG} >/dev/null
                    echo "Docker image verified"
                '''
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} |
                    docker login --username AWS --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        stage('Tag Image for ECR') {
            steps {
                sh '''
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} \
                    ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                    docker push \
                    ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                '''
            }
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
              k8s/deployment.yaml | kubectl apply -f -

            kubectl apply -f k8s/service.yaml

            kubectl rollout status deployment/cloudops-app \
              --timeout=180s
        '''
    }
}    

    post {
        success {
            echo 'CI pipeline succeeded. Docker image was pushed to ECR.'
        }
        failure {
            echo 'Pipeline failed. Check the stage logs.'
        }
    }
}

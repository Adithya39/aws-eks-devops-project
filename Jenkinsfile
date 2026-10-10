pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        IMAGE_NAME = 'cloudops-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Git checkout step') {
            steps {
                checkout scm
            }
        }

        stage('Validate the files') {
            steps {
                sh '''
                    test -f app/index.html
                    test -f Dockerfile
                    echo "Application and Dockerfile found"
                '''
            }
        }

        stage('Build the image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Verify the image') {
            steps {
                sh '''
                    docker image inspect ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo 'Docker image built and verified successfully.'
        }
        failure {
            echo 'Pipeline failed. Check the stage logs.'
        }
    }
}
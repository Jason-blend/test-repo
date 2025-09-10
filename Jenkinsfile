pipeline {
    agent any
    environment {
        GIT_TOKEN = credentials('github-pat') // Your GitHub PAT in Jenkins
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'jenkins-auto-upgrade', 
                    url: 'https://github.com/Jason-blend/test-repo.git',
                    credentialsId: 'github-pat'
            }
        }

        stage('Setup Python & Dependencies') {
            steps {
                sh '''
                #!/bin/bash
                python3 -m venv venv
                ./venv/bin/pip install --upgrade pip setuptools wheel
                ./venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Static Analysis - Bandit & Flake8') {
            steps {
                sh '''
                #!/bin/bash
                ./venv/bin/bandit -r . || true
                ./venv/bin/flake8 . || true
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                #!/bin/bash
                ./venv/bin/python -m unittest discover tests || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("my-flask-app")
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image my-flask-app
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop flask-app || true
                docker rm flask-app || true
                docker run -d -p 5000:5000 --name flask-app my-flask-app
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

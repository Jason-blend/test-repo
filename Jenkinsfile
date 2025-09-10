pipeline {
    agent any
    environment {
        GIT_TOKEN = credentials('github-pat') // GitHub PAT from Jenkins credentials
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'jenkins-auto-upgrade', 
                    url: 'https://github.com/Jason-blend/test-repo.git',
                    credentialsId: 'github-pat'
            }
        }

      stage('Setup Python') {
    steps {
        sh '''
            #!/bin/bash
            python3 -m venv venv
            source venv/bin/activate
            pip install --upgrade pip setuptools wheel
            pip install -r requirements.txt
        '''
    }
}


        stage('Static Analysis - Bandit & Flake8') {
            steps {
                sh '''
                    source venv/bin/activate
                    pip install bandit flake8
                    bandit -r .
                    flake8 .
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                    source venv/bin/activate
                    pip install pytest
                    pytest -v --maxfail=1 --disable-warnings
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("my-flask-app:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --exit-code 1 --severity HIGH,CRITICAL my-flask-app:${BUILD_NUMBER}
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker stop flask-app || true
                    docker rm flask-app || true
                    docker run -d -p 5000:5000 --name flask-app my-flask-app:${BUILD_NUMBER}
                '''
            }
        }
    }

    post {
        always {
            echo "Cleaning up..."
            sh 'docker system prune -f'
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}

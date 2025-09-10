pipeline {
    agent any
    environment {
        GIT_TOKEN = credentials('github-pat')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'jenkins-auto-upgrade', 
                    url: 'https://github.com/Jason-blend/test-repo.git',
                    credentialsId: 'github-pat'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m pip install --upgrade pip setuptools wheel
                    python3 -m pip install -r requirements.txt
                '''
            }
        }

        stage('Static Analysis') {
            steps {
                sh '''
                    python3 -m pip install bandit flake8
                    bandit -r .
                    flake8 .
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
                    trivy image --format json -o trivy-reports/trivy-report.json my-flask-app
                    trivy image --format template --template trivy-reports/html.tpl -o trivy-reports/trivy-report.html my-flask-app
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh 'docker run -d -p 5000:5000 --name my-flask-app my-flask-app'
            }
        }
    }
}

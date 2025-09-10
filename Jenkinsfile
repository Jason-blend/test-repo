pipeline {
    agent any
    environment {
        GIT_TOKEN = credentials('github-pat') // Jenkins credential ID for GitHub PAT
        IMAGE_NAME = "my-flask-app"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "https://github.com/Jason-blend/test-repo.git"
            }
        }

        stage('Setup Python') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip setuptools wheel
                    if [ -f requirements.txt ]; then
                        pip install -r requirements.txt
                    fi
                '''
            }
        }

        stage('Static Analysis - Bandit & Flake8') {
            steps {
                sh '''
                    . venv/bin/activate
                    pip install bandit flake8
                    bandit -r . -f html -o bandit-report.html || true
                    flake8 . --exit-zero --format=html --htmldir=flake8-report || true
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    pip install pytest pytest-html
                    pytest --maxfail=1 --disable-warnings -q --html=pytest-report.html || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}")
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    mkdir -p trivy-reports
                    trivy image --format json -o trivy-reports/trivy-report.json ${IMAGE_NAME} || true
                    trivy image --format template --template "@/root/contrib/html.tpl" -o trivy-reports/trivy-report.html ${IMAGE_NAME} || true
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker run -d -p 5000:5000 --name my-flask-job ${IMAGE_NAME} || true
                '''
            }
        }
    }
    post {
        always {
            publishHTML([
                reportName : 'Bandit Report',
                reportDir  : '.',
                reportFiles: 'bandit-report.html',
                keepAll: true, alwaysLinkToLastBuild: true, allowMissing: true
            ])
            publishHTML([
                reportName : 'Flake8 Report',
                reportDir  : 'flake8-report',
                reportFiles: 'index.html',
                keepAll: true, alwaysLinkToLastBuild: true, allowMissing: true
            ])
            publishHTML([
                reportName : 'Pytest Report',
                reportDir  : '.',
                reportFiles: 'pytest-report.html',
                keepAll: true, alwaysLinkToLastBuild: true, allowMissing: true
            ])
            publishHTML([
                reportName : 'Trivy Vulnerability Report',
                reportDir  : 'trivy-reports',
                reportFiles: 'trivy-report.html',
                keepAll: true, alwaysLinkToLastBuild: true, allowMissing: true
            ])
        }
    }
}

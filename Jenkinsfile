pipeline {
    agent any

    environment {
        IMAGE_NAME = "notes-app"
        REPORT_DIR = "reports"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Jason-blend/test-repo.git'
            }
        }

        stage('Setup Python') {
            steps {
                sh '''
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
                mkdir -p ${REPORT_DIR}
                source venv/bin/activate
                bandit -r app.py -f html -o ${REPORT_DIR}/bandit-report.html || true
                flake8 --exit-zero --format=html --htmldir=${REPORT_DIR}/flake8-report || true
                '''
            }
            post {
                always {
                    publishHTML([
                        reportDir: "${REPORT_DIR}",
                        reportFiles: "bandit-report.html",
                        reportName: "Bandit Security Report"
                    ])
                    publishHTML([
                        reportDir: "${REPORT_DIR}/flake8-report",
                        reportFiles: "index.html",
                        reportName: "Flake8 Lint Report"
                    ])
                }
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                source venv/bin/activate
                pytest --junitxml=${REPORT_DIR}/pytest-report.xml || true
                '''
            }
            post {
                always {
                    junit "${REPORT_DIR}/pytest-report.xml"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                mkdir -p trivy-reports
                trivy image --format template --template "@/root/contrib/html.tpl" -o trivy-reports/trivy-report.html ${IMAGE_NAME} || true
                trivy image --format json -o trivy-reports/trivy-report.json ${IMAGE_NAME} || true
                '''
            }
            post {
                always {
                    publishHTML([
                        reportDir: "trivy-reports",
                        reportFiles: "trivy-report.html",
                        reportName: "Trivy Vulnerability Report"
                    ])
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker rm -f ${IMAGE_NAME} || true
                docker run -d --name ${IMAGE_NAME} -p 5000:5000 ${IMAGE_NAME}
                '''
            }
        }
    }
}

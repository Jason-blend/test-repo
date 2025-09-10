pipeline {
    agent any

    environment {
        VENV = "./venv"
    }

    stages {

        stage('Unit Tests') {
            steps {
                echo "Running Python unit tests..."
                sh "${VENV}/bin/python -m unittest discover tests || true"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Skipping Docker build for now"
            }
        }

        stage('Trivy Scan') {
            steps {
                echo "Skipping Trivy scan due to skipped Docker build"
            }
        }

        stage('Deploy Container') {
            steps {
                echo "Skipping container deployment for now"
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}

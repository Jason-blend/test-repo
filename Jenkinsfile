pipeline {
    agent any
    environment {
        GIT_TOKEN = credentials('github-pat') // We’ll configure this later
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Jason-blend/test-repo.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("my-flask-app")
                }
            }
        }
    }
}

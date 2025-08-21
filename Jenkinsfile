pipeline {
    agent any
    stages {
        stage('Run Python') {
            agent {
                dockerContainer('python:3.12') {
                    args '-u'
                }
            }
            steps {
                sh 'python3 hello-world.py'
            }
        }
    }
}

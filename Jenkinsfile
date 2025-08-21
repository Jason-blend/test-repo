pipeline {
    agent any
    stages {
        stage('Run Python') {
            agent {
                docker {
                    image 'python:3.12'
                    args '-u'   // optional: makes output unbuffered
                }
            }
            steps {
                sh 'python3 hello-world.py'
            }
        }
    }
}

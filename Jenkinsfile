pipeline {
    agent any
    stages {
        stage('Run Python') {
            steps {
                sh 'python3 hello-world.py || echo "Python3 not found"'
            }
        }
    }
}

stage('Unit Tests') {
    steps {
        sh './venv/bin/python -m pytest tests'
    }
}

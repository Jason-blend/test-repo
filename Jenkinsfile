pipeline {
    agent any

    stages {
        stage('Setup Python') {
            steps {
                script {
                    if (isUnix()) {
                        // Linux / macOS
                        sh '''
                        if ! command -v python3 &> /dev/null; then
                            echo "Python3 not found, installing..."
                            sudo apt-get update
                            sudo apt-get install -y python3
                        else
                            echo "Python3 is already installed"
                        fi
                        '''
                    } else {
                        // Windows
                        bat '''
                        where python >nul 2>nul
                        if %errorlevel% neq 0 (
                            echo Python not found. Installing Python...
                            powershell -Command "Start-Process 'msiexec.exe' -ArgumentList '/i https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe /quiet InstallAllUsers=1 PrependPath=1' -Wait"
                        ) else (
                            echo Python is already installed
                        )
                        '''
                    }
                }
            }
        }

        stage('Run Python Script') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'python3 hello-world.py'
                    } else {
                        bat 'python hello-world.py'
                    }
                }
            }
        }
    }
}

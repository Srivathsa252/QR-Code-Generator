pipeline {
    agent {
        docker {
            image 'python:3.9'
        }
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building the application...'
                // Add build steps here
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                // Add test commands here
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
                // Add deployment steps here
            }
        }
    }
}

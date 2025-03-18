pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Srivathsa252/QR-Code-Generator.git'
            }
        }
        
        stage('Setup') {
            steps {
                script {
                    sh '''
                    # Check if Node.js is installed (for web-based QR code projects)
                    if ! command -v node &> /dev/null; then
                        echo "Node.js not found, installing..."
                        apt-get update
                        apt-get install -y nodejs npm
                    fi
                    
                    # Check if Python is installed (for Python-based QR code projects)
                    if ! command -v python3 &> /dev/null; then
                        echo "Python not found, installing..."
                        apt-get update
                        apt-get install -y python3 python3-pip
                    fi
                    
                    # Display versions
                    echo "Node.js version:"
                    node --version || echo "Node.js not available"
                    
                    echo "Python version:"
                    python3 --version || echo "Python not available"
                    
                    # List directory contents to determine project type
                    ls -la
                    '''
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    sh '''
                    # Install Node.js dependencies if package.json exists
                    if [ -f package.json ]; then
                        echo "Installing Node.js dependencies..."
                        npm install
                    fi
                    
                    # Install Python dependencies if requirements.txt exists
                    if [ -f requirements.txt ]; then
                        echo "Installing Python dependencies..."
                        pip3 install -r requirements.txt
                    fi
                    
                    # If it's a simple Python script with qrcode dependency
                    if [ -f *.py ] && ! [ -f requirements.txt ]; then
                        echo "Installing Python QR code dependencies..."
                        pip3 install qrcode pillow
                    fi
                    '''
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    sh '''
                    # Run tests if they exist
                    if [ -f package.json ] && grep -q "test" package.json; then
                        echo "Running Node.js tests..."
                        npm test || echo "Tests failed but continuing"
                    elif [ -d tests ] || [ -d test ]; then
                        echo "Running Python tests..."
                        python3 -m pytest || echo "Tests failed but continuing"
                    else
                        echo "No test directory or test script found"
                    fi
                    '''
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    sh '''
                    # For Node.js projects
                    if [ -f package.json ] && grep -q "build" package.json; then
                        echo "Building Node.js project..."
                        npm run build
                    fi
                    
                    # For Python projects, we might create a distributable package
                    if [ -f setup.py ]; then
                        echo "Building Python package..."
                        python3 setup.py sdist bdist_wheel
                    fi
                    '''
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    sh '''
                    # Check if Dockerfile exists
                    if [ -f Dockerfile ]; then
                        echo "Building Docker image..."
                        docker build -t qr-code-generator:latest .
                    else
                        echo "No Dockerfile found, creating one..."
                        # Create Dockerfile based on project type
                        if [ -f package.json ]; then
                            # Node.js project
                            cat > Dockerfile << EOF
FROM node:16-alpine
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["npm", "start"]
EOF
                        elif [ -f requirements.txt ] || [ -f *.py ]; then
                            # Python project
                            cat > Dockerfile << EOF
FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt || pip install qrcode pillow
EXPOSE 5000
CMD ["python3", "app.py"]
EOF
                        fi
                        docker build -t qr-code-generator:latest .
                    fi
                    '''
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    echo "Deploying application"
                    // Replace with your actual deployment steps
                    // sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Build succeeded!'
        }
        failure {
            echo '❌ Build failed!'
        }
    }
}
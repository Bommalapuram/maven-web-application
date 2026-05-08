pipeline {
    agent any

    tools {
        // Manage Jenkins > Tools lo Maven name 'maven-3' ani undali
        maven 'maven-3'
    }

    environment {
        DOCKER_IMAGE = "devpractice1/maven-web-application"
        DOCKER_HUB_CREDS = "docker-hub-creds"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Bommalapuram/maven-web-application.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'sonar-scanner'
                    withSonarQubeEnv('sonar-server') { 
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=maven-web-app"
                    }
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${env.BUILD_ID} ."
                    sh "docker tag ${DOCKER_IMAGE}:${env.BUILD_ID} ${DOCKER_IMAGE}:latest"
                    
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDS}", passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${env.BUILD_ID}"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

                stage('K8s Deployment') {
            steps {
                script {
                    // 'k8s-config-file' anedi meeru Jenkins Credentials lo ichina ID
                    withCredentials([file(credentialsId: 'k8s-config-file', variable: 'KUBECONFIG')]) {
                        
                        // IMAGE_NAME placeholder ni kotha build tag tho replace chesthunnam
                        sh "sed -i 's|IMAGE_NAME|${DOCKER_IMAGE}:${env.BUILD_ID}|g' deployment.yaml"
                        
                        // Jenkins Build server nundi Deployment server ki commands pampisthunnam
                        sh "kubectl --kubeconfig=${KUBECONFIG} apply -f deployment.yaml"
                    }
                }
            }
        }

    }
}

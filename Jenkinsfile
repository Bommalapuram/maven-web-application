pipeline {
    agent any

    tools {
        maven 'Maven3'   // Jenkins Tools lo meeru icchina Maven name
        jdk 'Java21'    // Jenkins Tools lo meeru icchina JDK name
    }

    environment {
        // SonarQube Details
        SONAR_SERVER_NAME = 'SonarQube' 
        
        // DockerHub Details
        DOCKER_HUB_USER = 'devpractice1'
        DOCKER_IMAGE_NAME = 'devpractice1/maven-web-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        
        // GitHub Repo (Updated with correct path)
        GIT_REPO_URL = 'https://github.com/Bommalapuram/maven-web-application.git'
    }

    stages {
       stage('Checkout') {
            steps {
                // Correct way to pull code
                git branch: 'master', 
                    credentialsId: 'git-cred', 
                    url: 'https://github.com/Bommalapuram/maven-web-application.git'
            }
        }


        stage('Maven Build') {
            steps {
                // War file build chestundi
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
    steps {
        // Direct ga Jenkins System Config lo unna name ikkada ivvandi
        withSonarQubeEnv('SonarQube') {
            sh 'mvn sonar:sonar -Dsonar.projectKey=Maven-Web-App'
        }
    }
}


        stage('Docker Build & Push') {
            steps {
                script {
                    // DockerHub Login mariyu Push
                    withCredentials([usernamePassword(credentialsId: 'docker-cred', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "docker build -t ${env.DOCKER_IMAGE_NAME}:${env.DOCKER_TAG} ."
                        sh "docker tag ${env.DOCKER_IMAGE_NAME}:${env.DOCKER_TAG} ${env.DOCKER_IMAGE_NAME}:latest"
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        sh "docker push ${env.DOCKER_IMAGE_NAME}:${env.DOCKER_TAG}"
                        sh "docker push ${env.DOCKER_IMAGE_NAME}:latest"
                    }
                }
            }
        }

        // Kubernetes setup tarvata ee stage uncomment cheyyandi
        /*
        stage('K8s Deployment (EKS)') {
            steps {
                script {
                    sh "sed -i 's|IMAGE_NAME|${env.DOCKER_IMAGE_NAME}:${env.DOCKER_TAG}|g' deployment.yaml"
                    sh "kubectl apply -f deployment.yaml"
                }
            }
        }
        */
    }

    post {
        always {
            echo "Build Finished."
        }
        success {
            echo "Application ready for Deployment!"
        }
        failure {
            echo "Pipeline Failed. Check logs for details."
        }
    }
}

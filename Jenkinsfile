pipeline {
    agent any

    environment {
        // SonarQube Details
        SONAR_SERVER_NAME = 'SonarQube' // Jenkins System Configuration lo nuvvu icchina Name idi
        
        // DockerHub Details
        DOCKER_HUB_USER = 'devpractice1'
        DOCKER_IMAGE_NAME = 'devpractice1/maven-web-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        
        // GitHub Repo
        GIT_REPO_URL = 'https://github.com'
    }

    stages {
        stage('Checkout') {
            steps {
                // GitHub credentials use chesi code pull chestundi
                git branch: 'master', 
                    credentialsId: 'git-cred', 
                    url: "${GIT_REPO_URL}"
            }
        }

        stage('Maven Build') {
            steps {
                // War file create chestundi
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // SonarQube server ki code analysis pampistundi
                withSonarQubeEnv("${SONAR_SERVER_NAME}") {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=Maven-Web-App -Dsonar.login=squ_ac8a0550cf5a0a5810597ebec174617d5a4e24c8'
                }
            }
        }

        stage('Docker Build') {
            steps {
                // Docker image build chestundi
                sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ."
                sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${DOCKER_IMAGE_NAME}:latest"
            }
        }

        stage('Docker Push') {
            steps {
                // DockerHub ki image push chestundi
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-cred', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        sh "docker push ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('K8s Deployment (EKS)') {
            steps {
                script {
                    // Deployment file lo image name ni update chestundi
                    sh "sed -i 's|IMAGE_NAME|${DOCKER_IMAGE_NAME}:${DOCKER_TAG}|g' deployment.yaml"
                    
                    // Kubernetes ki deploy chestundi (Jenkins server lo kubeconfig setup undali)
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl apply -f service.yaml"
                }
            }
        }
    }

    post {
        success {
            echo "Successfully Deployed to EKS!"
            // Ikada SNS trigger add cheyyochu
        }
        failure {
            echo "Pipeline Failed. Please check logs."
        }
    }
}

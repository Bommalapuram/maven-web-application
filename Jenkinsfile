pipeline {
    agent any

    tools {
        // Manage Jenkins > Tools lo Maven name 'maven-3' ani undali
        maven 'maven-3'
    }

    environment {
        DOCKER_IMAGE = "devpractice1/maven-web-application"
        DOCKER_HUB_CREDS = "docker-hub-creds" // Jenkins Credentials ID
    }

    stages {
        stage('Checkout') {
            steps {
                // Public repo kabatti credentials avasaram ledu
                git 'https://github.com/Bommalapuram/maven-web-application.git'
            }
        }

        stage('Maven Build') {
            steps {
                // Code compile ayyi target folder lo .war file create avthundi
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
                    // Image ni build chesi version tag (${env.BUILD_ID}) tho push chesthunnam
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
    }
}








  /*
pipeline {
    agent any

    tools {
        maven 'Maven3'   // Jenkins Tools lo meeru icchina Maven name
        jdk 'Java21'    // Jenkins Tools lo meeru icchina JDK name
    }

    environment {
        
        
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

       stage('OWASP Security Scan') {
    steps {
        // 1. Tool name matching with Jenkins Global Tool Configuration
        dependencyCheck tool: 'OWASP-Check'
        
        // 2. Report generate cheyyadam
        dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
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
 */
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
        
    }
*/
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

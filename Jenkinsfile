pipeline {
    agent any
    
    tools {
        jdk 'jdk21'
        maven 'maven3'
        nodejs 'node'
    }

    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Git Pull') {
            steps {
                git branch: 'dev', credentialsId: 'git-cred-d', url: 'https://github.com/shumisoft/realtime-chatapp-service-registery'
            }
        }
        stage('Maven Compile') {
            steps {
               sh 'mvn compile'
            }
        }
        stage('Trivy Vulnarability Scan') {
            steps {
                sh 'trivy fs -f table -o trivy-rtca-sreg-fs-report.html . && cat trivy-rtca-sreg-fs-report.html'
            }
        }
        stage('Build, Test & SonarQube') {
            steps {
                withSonarQubeEnv('SonarQubeOC-DS') {
                    sh '''
                        mvn clean verify -DskipTests sonar:sonar \
                          -Dsonar.projectKey=Realtime_Chatapp-Service_Registery \
                          -Dsonar.projectName=Realtime-Chatapp-Service-Registery \
                          -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml
                    '''
                }
            }
        }
        stage('Sonar Quality Gate') {
            steps {
                script {
                  waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube-cred-d' 
                }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }
        stage('Build & Push Multi-Arch Docker Image') {
            steps {
               script {
                   withDockerRegistry(credentialsId: 'dockerhub-cred-d') {
                      sh "docker buildx create --name mybuilder --use"
                       sh """docker buildx build \
                       --platform linux/amd64,linux/arm64 \
                       -t dipanshushukla/realtime-chatapp-service-registery:latest-dev \
                       --push ."""
                   }
               }
            }
        }
        stage('Trivy Docker Image Scan') {
            steps {
                sh 'trivy image -f table -o trivy-rtca-sreg-container-image-report.html dipanshushukla/realtime-chatapp-service-registery:latest-dev && cat trivy-rtca-sreg-container-image-report.html'
            }
        }
    }
}
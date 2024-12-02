pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
        maven 'maven 3.8.6'
    }
    
    environment{
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout ') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/Sunilmargale/SpringBoot-WebApplication.git'
            }
        }
        
        stage('Code Compile') {
            steps {
                    sh "mvn compile"
            }
        }
        
        stage('Run Test Cases') {
            steps {
                    sh "mvn test"
            }
        }
        
        stage('Sonarqube Analysis') {
            steps {
                    withSonarQubeEnv('sonar-scanner') {
                        sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Java-WebApp \
                        -Dsonar.java.binaries=. \
                        -Dsonar.projectKey=Java-WebApp '''
    
                }
            }
        }
        
        stage('OWASP Dependency Check') {
            steps {
                   dependencyCheck additionalArguments: '--scan ./   ', odcInstallation: 'DC'
                   dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('Maven Build') {
            steps {
                    sh "mvn clean compile"
            }
        }
        
        stage('Docker Build & Push') {
            steps {
                   script {
                       withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                            sh "docker build -t webapp ."
                            sh "docker tag webapp sunilmargale/webapp:latest"
                            sh "docker push sunilmargale/webapp:latest "
                        }
                   } 
            }
        }

        stage('Deploy to container') {
            steps {
                sh "docker run -dp 8081:8081 sunilmargale/webapp:latest"
            }
        }
        
        stage('Docker Image scan') {
            steps {
                    sh "trivy image sunilmargale/webapp:latest "
            }
        }
    }
}

pipeline {
    agent {
        docker {
            image 'maven:3.9-eclipse-temurin-17'
            args '-v /var/jenkins_home/.m2:/root/.m2 --network pipeline-server_devops-spring'
        }
    }

    triggers {
        githubPush() // Explicitly tell this pipeline to trigger on GitHub push events-check 
    }

    stages {
        stage('Test SonarQube Credential') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube-token-jenkins', variable: 'SONAR_TOKEN')]) {
                    sh 'echo "Credential exists and value length is: ${#SONAR_TOKEN}"'
                }
            }
        }

        stage('Test Credentials - github') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-pat-jenkins', 
                                                passwordVariable: 'GIT_TOKEN', 
                                                usernameVariable: 'GIT_USERNAME')]) {
                    sh 'echo "Credential access of git successful"'
                }
            }
        }

//


        stage('Build') {
            steps {
                sh 'mvn -B clean package -DskipTests -Dcheckstyle.skip=true'
                echo 'Build completed'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Test') {
            steps {
                 sh 'mvn test -Dcheckstyle.skip=true'
                echo 'Tests completed'
            }
        }

        stage('Run the Jar file') {
            // /var/jenkins_home/workspace/spring-petclinic-multibranch_main/target/classes/git.properties
            steps {
                script {
                    // Build a Docker image with your JAR
                    sh "docker build -t myapp:${BUILD_NUMBER} ."
                    
                    // Run the container on the same network as ZAP
                    sh "docker run -d --name myapp-${BUILD_NUMBER} --network pipeline-server_devops-spring -p 8090:8090 myapp:${BUILD_NUMBER}"
                    
                    // Wait for application to start
                    sh "sleep 30"
                    
                    // Set the application URL for ZAP to use
                    env.APP_URL = "http://myapp-${BUILD_NUMBER}:8090"
                }
            }
        }

        stage('Pre ZAP Scan') {
            steps {
                script {
                    // sh 'docker exec -u 0 $(docker ps -q) apt-get update && apt-get install -y iputils-ping'
                    // sh 'ping -c 4 zap || echo "Host unreachable but continuing"'
                    sh 'curl -v http://zap:8080/JSON/core/view/version/ || echo "ZAP API unreachable"'
                }
            }
        }


        stage('ZAP Scan') {
            steps {
                script {
                    // Wait for ZAP to be fully started 
                    sh 'sleep 10'

                    // sh 'ping -c 4 zap'  // Check if host is reachable
                    sh 'curl -v http://zap:8080/JSON/core/view/version/'  // Test basic ZAP API connectivity

                    
                    def targetUrl = "http://juice-shop:3000"
                    
                    // Spider scan to discover the site structure
                    sh """
                        curl "http://zap:8080/JSON/spider/action/scan/?url=${targetUrl}&recurse=true&maxChildren=10&contextName=&subtreeOnly=false" -s > /dev/null
                        
                        # Wait for spider to complete - poll the status
                        while [ \$(curl -s "http://zap:8080/JSON/spider/view/status/" | grep -o '"status":[0-9]*' | cut -d ':' -f 2) -ne 100 ]; do
                            echo "Spider in progress..."
                            sleep 5
                        done
                        echo "Spider completed"
                    """
                    
                    // Run the active scan
                    sh """
                        curl "http://zap:8080/JSON/ascan/action/scan/?url=${targetUrl}&recurse=true&inScopeOnly=false&scanPolicyName=&method=&postData=&contextId=" -s > /dev/null
                        
                        # Wait for active scan to complete - poll the status
                        while [ \$(curl -s "http://zap:8080/JSON/ascan/view/status/" | grep -o '"status":[0-9]*' | cut -d ':' -f 2) -ne 100 ]; do
                            echo "Active scan in progress..."
                            sleep 10
                        done
                        echo "Active scan completed"
                    """
                }
            }
        }

        stage('Generate ZAP Report') {
            steps {
                script {
                    // Create a directory for reports
                    sh 'mkdir -p dummyFolder'
                    
                    // Generate HTML report
                    sh 'curl "http://zap:8080/OTHER/core/other/htmlreport/" -o dummyFolder/zap-report.html'
                    
                    // Generate XML report for potential integration with other tools
                    sh 'curl "http://zap:8080/OTHER/core/other/xmlreport/" -o dummyFolder/zap-report.xml'
                    
                    // Copy reports to mounted volume for persistence
                    sh 'cp -r dummyFolder/* /var/zap/zap-reports/'
                }
            }
        }

        stage('Publish ZAP Report') {
            steps {
                // Archive the reports as artifacts
                archiveArtifacts artifacts: 'zap-reports/**', fingerprint: true
                
                // Publish HTML report
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'zap-reports',
                    reportFiles: 'zap-report.html',
                    reportName: 'ZAP Security Report',
                    reportTitles: 'ZAP Scan Results'
                ])
            }
        }

        stage('Static Analysis') {
            steps {
                withSonarQubeEnv('LocalSonarEnv') {
                    withCredentials([string(credentialsId: 'sonarqube-token-jenkins', variable: 'SONAR_TOKEN')]) {
                        sh 'mvn sonar:sonar -DskipTests -Dcheckstyle.skip=true -Dsonar.login=${SONAR_TOKEN} -Dsonar.host.url=http://sonarqube:9000'
                    }
                }
            }
        }

    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}


// pipeline {
//     agent any
    
//     triggers {
//         githubPush() // Explicitly tell this pipeline to trigger on GitHub push event
//     }

//     stages {
//         stage('Test') {
//             steps {
//                 echo 'This is a test pipeline'
//                 sh 'ls -la'  // List files to verify checkoutsasasas
//             }
//         }
//     }
// }

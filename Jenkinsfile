pipeline {
    agent {
        docker {
            image 'maven:3.9-eclipse-temurin-17'
            args '-v /var/jenkins_home/.m2:/root/.m2 --network pipeline-server_devops-spring -u root'
        }
    }

    triggers {
        githubPush() // Explicitly tell this pipeline to trigger on GitHub push events-checkss
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

        stage('Test Credentials - aws.pem') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    sh 'echo "Credential access of git successful"'
                }
            }
        }


        // stage('Build') {
        //     steps {
        //         sh 'mvn -B clean package -DskipTests -Dcheckstyle.skip=true'
        //         echo 'Build completed'
        //         archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        //     }
        // }

        // stage('Test') {
        //     steps {
        //          sh 'mvn test -Dcheckstyle.skip=true'
        //         echo 'Tests completed'
        //     }
        // }

        // stage('Run Application Locally') {
        //     steps {
        //         script {
        //             // Find the JAR files-
        //             def jarFile = sh(script: 'find target -name "*.jar" | grep -v original | head -1', returnStdout: true).trim()
                    
        //             // Kill any previously running instance
        //             sh """
        //                 PID=\$(ps -ef | grep java | grep -v grep | grep -v jenkins | awk '{print \$2}')
        //                 if [ ! -z "\$PID" ]; then
        //                     echo "Killing previous application instance (PID: \$PID)"
        //                     kill -9 \$PID || true
        //                 fi
        //             """
                    
        //             // Run the JAR file in the background
        //             sh """
        //                 nohup java -jar ${jarFile} --server.port=8090 > app.log 2>&1 &
        //                 echo \$! > app.pid
                        
        //                 # Wait for application to start
        //                 echo "Waiting for application to start..."
        //                 sleep 30
                        
        //                 # Verify the application is running
        //                 curl -s http://localhost:8090/actuator/health || echo "Application may not be fully started yet"
        //             """
                    
        //             // Store the application URL for ZAP to use
        //             env.APP_URL = "http://localhost:8090"
        //         }
        //     }
        // }


        // stage('Pre ZAP Scan') {
        //     steps {
        //         script {
        //             // sh 'docker exec -u 0 $(docker ps -q) apt-get update && apt-get install -y iputils-ping'
        //             // sh 'ping -c 4 zap || echo "Host unreachable but continuing"'
        //             sh 'curl -v http://zap:8082/JSON/core/view/version/ || echo "ZAP API unreachable"'
        //         }
        //     }
        // }


        // stage('ZAP Scan') {
        //     steps {
        //         script {
        //             // Wait for ZAP to be fully started 
        //             sh 'sleep 10'

        //             // sh 'ping -c 4 zap'  // Check if host is reachable
        //             sh 'curl -v http://zap:8082/JSON/core/view/version/'  // Test basic ZAP API connectivity

                    
        //             def targetUrl = "http://myapp-${BUILD_NUMBER}:8090"
        //             // def targetUrl = "http://localhost:8888"
                    
        //             // Spider scan to discover the site structure
        //             sh """
        //                 curl "http://zap:8082/JSON/spider/action/scan/?url=${targetUrl}&recurse=true&maxChildren=10&contextName=&subtreeOnly=false" -s > /dev/null
                        
        //                 # Wait for spider to complete - poll the status
        //                 while [ \$(curl -s "http://zap:8082/JSON/spider/view/status/" | grep -o '"status":[0-9]*' | cut -d ':' -f 2) -ne 100 ]; do
        //                     echo "Spider in progress..."
        //                     sleep 5
        //                 done
        //                 echo "Spider completed"
        //             """
                    
        //             // Run the active scan
        //             sh """
        //                 curl "http://zap:8082/JSON/ascan/action/scan/?url=${targetUrl}&recurse=true&inScopeOnly=false&scanPolicyName=&method=&postData=&contextId=" -s > /dev/null
                        
        //                 # Wait for active scan to complete - poll the status
        //                 while [ \$(curl -s "http://zap:8082/JSON/ascan/view/status/" | grep -o '"status":[0-9]*' | cut -d ':' -f 2) -ne 100 ]; do
        //                     echo "Active scan in progress..."
        //                     sleep 10
        //                 done
        //                 echo "Active scan completed"
        //             """
        //         }
        //     }
        // }

        // stage('Generate ZAP Report') {
        //     steps {
        //         script {
        //             // Create a directory for reports in the workspace
        //             sh 'mkdir -p zap-reports'
                    
        //             // Generate HTML report directly to workspace
        //             sh 'curl "http://zap:8082/OTHER/core/other/htmlreport/" -o zap-reports/zap-report.html'
                    
        //             // Generate XML report directly to workspace
        //             sh 'curl "http://zap:8082/OTHER/core/other/xmlreport/" -o zap-reports/zap-report.xml'
        //         }
        //     }
        // }

        // stage('Publish ZAP Report') {
        //     steps {
        //         // Archive the reports as artifacts
        //         archiveArtifacts artifacts: 'zap-reports/**', fingerprint: true
                
        //         // Publish HTML report
        //         publishHTML([
        //             allowMissing: false,
        //             alwaysLinkToLastBuild: true,
        //             keepAll: true,
        //             reportDir: 'zap-reports',
        //             reportFiles: 'zap-report.html',
        //             reportName: 'ZAP Security Report',
        //             reportTitles: 'ZAP Scan Results'
        //         ])
        //     }
        // }

        // stage('Static Analysis') {
        //     steps {
        //         withSonarQubeEnv('LocalSonarEnv') {
        //             withCredentials([string(credentialsId: 'sonarqube-token-jenkins', variable: 'SONAR_TOKEN')]) {
        //                 sh 'mvn sonar:sonar -DskipTests -Dcheckstyle.skip=true -Dsonar.login=${SONAR_TOKEN} -Dsonar.host.url=http://sonarqube:9000'
        //             }
        //         }
        //     }
        // }

        stage('Run Ansible Playbook') {
            steps {
                sh 'apt-get update && apt-get install -y ansible'
                sh 'ls -la'
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    ansiblePlaybook(
                        playbook: './playbook.yaml',
                        inventory: './hosts.ini',
                        installation: 'ansible', // Name from Global Tool Configuration
                        extras: '--private-key=${SSH_KEY}'
                    )
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

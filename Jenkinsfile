pipeline {
    agent {
        docker {
            image 'maven:3.9-eclipse-temurin-17'
            args '-v $HOME/.m2:/root/.m2'  // Cache Maven dependencies
        }
    }

    triggers {
        githubPush() // Explicitly tell this pipeline to trigger on GitHub push events-check now
    }

    stages {
        stage('Test Credentials - sonar') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube-token-jenkins', variable: 'SONAR_TOKEN')]) {
                    sh 'echo "Credential access of sonar successful"'
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



        stage('Build') {
            steps {
                sh 'mvn -B clean package -DskipTests'
                echo 'Build completed'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
                echo 'Tests completed'
            }
        }

        stage('Static Analysis') {
            steps {
                withSonarQubeEnv('LocalSonar') {
                    withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                        sh 'mvn sonar:sonar -Dsonar.login=${SONAR_TOKEN} -Dsonar.host.url=http://sonarqube:9000'
                    }
                }
            }
        }
        // stage('Pre ZAP Scan') {
        //     steps {
        //         script {
        //             sh 'docker exec -u 0 $(docker ps -q) apt-get update && apt-get install -y iputils-ping'
        //             sh 'ping -c 4 zap || echo "Host unreachable but continuing"'
        //             sh 'curl -v http://zap:8080/JSON/core/view/version/ || echo "ZAP API unreachable"'
        //         }
        //     }
        // }


        // stage('ZAP Scan') {
        //     steps {
        //         script {
        //             // Wait for ZAP to be fully started 
        //             sh 'sleep 10'

        //             sh 'ping -c 4 zap'  // Check if host is reachable
        //             sh 'curl -v http://zap:8080/JSON/core/view/version/'  // Test basic ZAP API connectivity

                    
        //             def targetUrl = "http://juice-shop:3000"
                    
        //             // Spider scan to discover the site structure
        //             sh """
        //                 curl "http://zap:8080/JSON/spider/action/scan/?url=${targetUrl}&recurse=true&maxChildren=10&contextName=&subtreeOnly=false" -s > /dev/null
                        
        //                 # Wait for spider to complete - poll the status
        //                 while [ \$(curl -s "http://zap:8080/JSON/spider/view/status/" | grep -o '"status":[0-9]*' | cut -d ':' -f 2) -ne 100 ]; do
        //                     echo "Spider in progress..."
        //                     sleep 5
        //                 done
        //                 echo "Spider completed"
        //             """
                    
        //             // Run the active scan
        //             sh """
        //                 curl "http://zap:8080/JSON/ascan/action/scan/?url=${targetUrl}&recurse=true&inScopeOnly=false&scanPolicyName=&method=&postData=&contextId=" -s > /dev/null
                        
        //                 # Wait for active scan to complete - poll the status
        //                 while [ \$(curl -s "http://zap:8080/JSON/ascan/view/status/" | grep -o '"status":[0-9]*' | cut -d ':' -f 2) -ne 100 ]; do
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
        //             // Create a directory for reports
        //             sh 'mkdir -p zap-reports'
                    
        //             // Generate HTML report
        //             sh 'curl "http://zap:8080/OTHER/core/other/htmlreport/" -o zap-reports/zap-report.html'
                    
        //             // Generate XML report for potential integration with other tools
        //             sh 'curl "http://zap:8080/OTHER/core/other/xmlreport/" -o zap-reports/zap-report.xml'
                    
        //             // Copy reports to mounted volume for persistence
        //             sh 'cp -r zap-reports/* /var/jenkins_home/zap-reports/'
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

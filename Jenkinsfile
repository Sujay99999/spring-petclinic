pipeline {
    agent {
        docker {
            image 'maven:3.9-eclipse-temurin-17'
            args '-v /var/jenkins_home/.m2:/root/.m2 --network pipeline-server_devops-spring -u root'
        }
    }

    triggers {
        githubPush() // Explicitly tell this pipeline to trigger on GitHub push events-checks
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

        // stage('Run Ansible Playbook') {
        //     steps {
        //         sh 'apt-get update && apt-get install -y ansible openssh-client file'
        //         sh 'ls -la'
        //         withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
        //             // Debug the key
        //             sh 'file "${SSH_KEY}" || echo "File command failed"'
        //             sh 'wc -l "${SSH_KEY}" || echo "wc command failed"'
                    
        //             // Convert the key with literal \n to proper newlines
        //             sh '''
        //                 mkdir -p ~/.ssh
        //                 echo -e "$(cat ${SSH_KEY})" > ~/.ssh/id_rsa
        //                 chmod 600 ~/.ssh/id_rsa
        //                 ssh-keyscan -H ec2-3-149-234-178.us-east-2.compute.amazonaws.com >> ~/.ssh/known_hosts
                        
        //                 # Debug the converted key
        //                 echo "Number of lines in converted key:"
        //                 wc -l ~/.ssh/id_rsa
        //                 echo "First few lines of converted key:"
        //                 head -3 ~/.ssh/id_rsa
        //             '''
                    
        //             // Run the playbook with the fixed key
        //             ansiblePlaybook(
        //                 playbook: './playbook.yaml',
        //                 inventory: './hosts.ini',
        //                 installation: 'ansible',
        //                 extras: '--private-key=~/.ssh/id_rsa -e "ansible_ssh_common_args=\'-o StrictHostKeyChecking=no\'" -vvv'
        //             )
        //         }
        //     }
        // }

        stage('Run Ansible Playbook') {
            steps {
                sh 'apt-get update && apt-get install -y ansible openssh-client'
                sh '''
        mkdir -p ~/.ssh
        cat > ~/.ssh/id_rsa << 'EOL'
        -----BEGIN RSA PRIVATE KEY-----
        MIIEpAIBAAKCAQEA27RQc5rumQZ5flGbJQ9SNRJmJ9PjeJMFm/fx6u7a0Mla0bMj
        jHU/N3kJxPr4xwzyplJxtAB5ioEeXaDiUmH2b8SHiEw3OyrQyw+MWBtcTGPPnLOR
        B1jswAUfdxsFEO50t5oF2DOpp4qAPs/+bN5IUgxCqd3USMtDfbQ+tBGespXLdCXN
        39/fj8iQlyYupKdeLft73+NXXg5ETgzADoJWVPhuzpjhK4RERLVVfPaR3OV/93JC
        Mhvb9ECmW3TG3OiQcInEzwHS73vWJe4U6X1u5WZbzts6o35qUgF/tK1UHi/eB2KB
        NcvB4Peh7/rRfglEDzK0+D9cp+2iYKv3MblQNwIDAQABAoIBAAhWXGM2su09sKiZ
        gjCy1yTKcPP793rg4WqcyyJmNAmOSpMAoE25OU/qmPNPrtcm56JmKIhzKCmYYsWc
        0Fnd+9Mb+ySx97qYElpSWboSN7tyYjOJIOzNdBaJWztS3CtbUTSSdLxSoZKJD/rS
        O8531PjAHFuD3oVwqTwA9gwxSvtt38msVlOxpeQvhYFm+/3Wowoamt+Ina1hle2O
        BFKZyLtDI7dx/NiyRoe3s6T1wi3JSOnR5bZgYZpZt3FZAkVHXhQKZAwurBrJc2iG
        s/fNTYlwBDgi51lsX4WvsM75U7MbMmSlywoks81na+5MxhtmpEY3a8wiGgL8FCUP
        d0LNU3ECgYEA91CJwj+cCwBdYusIyRje6/QjvZsI8hxNhpM3P+R+9huiVHiS7Dwq
        W2uMTMzYJAMfaSs7v64LHfARBtprzv62DkS5FasN/V3ra/Z1yzleKKqlWqylflWO
        sQwNKuyDx1cJLOeMZP7GAZvzM/nT/PcYBOqoy9PFhBARB64WgkfeUjkCgYEA42uM
        ZjSzP7ujabEBW5RdZ/WHw9AtVvL6+H3MjtH+F4wBsrkT0rCmrQspt5wborQNP4ye
        URQqRbZv4D5jsYiXqDcW+teAGwCtUcrJqKUu4rfDaEJQI9LauwRc3Ms8hgrkqLMe
        GBqjjnAfxp4RyhzXi9gW0+F5umyen7ojXxBK9e8CgYAFTFhnLO2u3qchg1+Az2OX
        MnfBjBy48xpGE8lPORnvM9BadurO3MsbgkZTLuBChT6bBi4VgSkDzyzONMeye4py
        6837RNrb3rM4cOM9I1F9FYrNUn2JI1QXPubZUI/SKW8s4xkC4OJlDm47YtLDzJdb
        I5vSIgtNNProazZYPCnrIQKBgQCCtjoINJoiM5MFGHuTS380VWcnIOwuYZHmaUe9
        fuzwU8RWGRJPssDaDOR5Z/xqU9qZgBUuvMxfLTC4TqO2Uq/4O1G1807qNkVoEYo+
        qFJ+dOiXcCXnsTWO8D7/mMC8ul4aqHjPmeAP6loZKplG9bTd5+GW/q2cfPnfDHlw
        Fkk/eQKBgQD17eqDsMDgAKOx4DtiABFUL8EdQXTQu0dCe5GJnfl+BEkCncSqy57F
        JcREwahUB7DkU6PnS7Dj2OYy6zSWIHAn7XJBxTsToaiQfJXRBeMnmRRaTaBnrRaU
        iCeHB9eW5t1rochomKUUsfZEIXxnPAcF1Ad3LvZKZvFUZeez/Q+vhQ==
        -----END RSA PRIVATE KEY-----
        EOL
        chmod 600 ~/.ssh/id_rsa
        ssh-keyscan -H ec2-3-149-234-178.us-east-2.compute.amazonaws.com >> ~/.ssh/known_hosts
        ansible-playbook -i ./hosts.ini ./playbook.yaml -vvv
        '''
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

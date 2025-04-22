pipeline {
    agent any

    stages {
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

        // stage('Static Analysis') {
        //     steps {
        //         withSonarQubeEnv('SonarQube') {
        //             withCredentials([string(credentialsId: 'sonarqube-token-jenkins', variable: 'SONAR_TOKEN')]) {
        //                 sh 'mvn sonar:sonar -Dsonar.login=${SONAR_TOKEN} -Dsonar.host.url=http://sonarqube:9000'
        //             }
        //         }
        //     }
        // }

        // stage('ZAP Scan via API') {
        //     agent any // Switch back to Jenkins controller for this stagess
        //     steps {
        //         sh '''
        //         # Wait for ZAP to fully start
        //         sleep 10
        //         # Spider the app (adjust URL and port as needed)
        //         curl "http://zap:8080/JSON/spider/action/scan/?url=http://localhost:8080&apikey=zap-api-key"
        //         # Wait for spider to finish
        //         sleep 10
        //         # Active scan
        //         curl "http://zap:8080/JSON/ascan/action/scan/?url=http://localhost:8080&apikey=zap-api-key"
        //         # Wait for scan to complete
        //         sleep 30
        //         # Get HTML report
        //         curl "http://zap:8080/OTHER/core/other/htmlreport/?apikey=zap-api-key" -o zap-report.html
        //         '''
        //     }
        // }

        // stage('Publish ZAP Report') {
        //     agent any // Stay on Jenkins controller
        //     steps {
        //         publishHTML([
        //             allowMissing: false,
        //             alwaysLinkToLastBuild: true,
        //             reportName: 'ZAP Report',
        //             reportDir: '.',
        //             reportFiles: 'zap-report.html',
        //             keepAll: true
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




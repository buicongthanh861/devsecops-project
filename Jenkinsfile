pipeline {
    agent any

    tools {
        maven 'Maven_3_8_4' // Tên Maven đã cấu hình trong Jenkins
    }

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN')
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Sử dụng SonarQube server đã cấu hình trong Jenkins
                withSonarQubeEnv('sonarqube-server') {
                    // Chạy SonarScanner
                    sh """
                        sonar-scanner \
                          -Dsonar.projectKey=buicongthanh861_devsecops-project \
                          -Dsonar.organization=java-woof \
                          -Dsonar.host.url=https://sonarcloud.io \
                          -Dsonar.login=$SONAR_TOKEN
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Build và SonarCloud scan thành công 🎉'
        }
        failure {
            echo 'Có lỗi xảy ra '
        }
    }
}

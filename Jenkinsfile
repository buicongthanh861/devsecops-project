pipeline {
    agent any

    tools {
        maven 'Maven_3_8_4'
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
    environment {
        scannerHome = tool 'sonar-scanner'
    }
    steps {
        withSonarQubeEnv('sonarqube-server') {
            sh "${scannerHome}/bin/sonar-scanner \
                -Dsonar.projectKey=buicongthanh861_devsecops-project \
                -Dsonar.organization=java-woof \
                -Dsonar.host.url=https://sonarcloud.io \
                -Dsonar.login=$SONAR_TOKEN"
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

pipeline {
    agent any
    tools {
        maven 'Maven_3_8_4'
        hudson.plugins.sonar.SonarRunnerInstallation 'sonar-scanner'
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean verify'
            }
        }

        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'sonar-scanner'
            }
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}

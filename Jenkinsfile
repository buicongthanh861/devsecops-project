pipeline {
   agent any
   tools {
      maven 'Maven_3_8_4'
   }
   stages{
      stage('ComplileadRunSonarAnaysis') {
            steps {
                  sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=buicongthanh861_devsecops-project -Dsonar.organization=java-woof -Dsonar.host.url=https://sonarcloud.io -Dsonar.token=$SONAR_TOKEN'
            }
      }
   }     
}
pipeline {
  agent any
  tools { 
        maven 'Maven_3_5_2'  
    }
   stages{
    stage('CompileandRunSonarAnalysis') {
            steps {	
		sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=buicongthanh861_devsecops-project -Dsonar.organization=java-woof -Dsonar.host.url=https://sonarcloud.io -Dsonar.token=8f1120bb65d5c3cdeee946d0fe1100215eff7468'
			}
        } 
  }
}

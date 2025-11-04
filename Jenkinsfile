pipeline {
  agent any
  tools { 
        maven 'Maven_3_8_4'  
    }
   stages{
    stage('CompileandRunSonarAnalysis') {
            steps {	
		sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=buicongthanh861_devsecops-project -Dsonar.organization=java-woof -Dsonar.host.url=https://sonarcloud.io -Dsonar.token=8f1120bb65d5c3cdeee946d0fe1100215eff7468'
			}
        }
      stage('RunSCAAnalysisUsingSnyk') {
            steps {
                  withCredentials([string(credentialsId: 'SNYK_TOKEN',variable: 'SNYK_TOKEN')]) {
                        sh 'mvn snyk:test -fn'
                  }
            }
      }
  }
      stage('Build') {
            steps {
                  script{
                        withDockerRegistry([credentialsId: "dockerlogin", url: ""]) {
                                    app = docker.build("asg")
                        }
                  }
            }
      }
      stage('Push') {
            steps {
                  script{
                        docker.withRegistry('AWS ECR URL','ecr:ap-southest-1:aws-credentials') {
                              app.push("latest")
                        }
                  }
            }
      }
}



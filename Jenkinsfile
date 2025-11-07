pipeline {
  agent any

  tools { 
    maven 'Maven_3_8_4'
  }

  stages {

    stage('Compile and Run Sonar Analysis') {
      steps {	
        sh '''
        mvn clean verify sonar:sonar \
        -Dsonar.projectKey=buicongthanh861_devsecops-project \
        -Dsonar.organization=java-woof \
        -Dsonar.host.url=https://sonarcloud.io \
        -Dsonar.token=8f1120bb65d5c3cdeee946d0fe1100215eff7468
        '''
      }
    }

    stage('Run SCA Analysis Using Snyk') {
      steps {
        withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
          sh 'mvn snyk:test -fn'
        }
      }
    }

    stage('Build') {
      steps {
        script {
          withDockerRegistry([credentialsId: "dockerlogin", url: ""]) {
            app = docker.build("asg")
          }
        }
      }
    }

    stage('Push') {
      steps {
        script {
          docker.withRegistry(
            'https://770424767729.dkr.ecr.ap-southeast-1.amazonaws.com',
            'ecr:ap-southeast-1:aws-credentials'
          ) {
            app.push("latest")
          }
        }
      }
    }

    stage('Kubernetes Deployment of ASG buggy web Application') {
      steps {
        withKubeConfig([credentialsId: 'kubelogin']) {
          sh('kubectl delete all --all -n devsecops')
          sh('kubectl apply -f deployment.yaml --namespace devsecops')
        }
      }
    }

    stage('Wait for Testing') {
      steps {
        sh 'pwd'; sleep 180; echo "Application has been deployed on k8s"
      }
    }

    stage('Run DAST Using ZAP') {
      steps {
        withKubeConfig([credentialsId: 'kubelogin']) {
          sh('zap.sh -cmd -quickurl http://$(kubectl get services/asgbuggy --namespace=devsecops -o json| jq -r ".status.loadBalancer.ingress[] | .hostname") -quickprogress -quickout ${WORKSPACE}/zap_report.html')
          archiveArtifacts artifacts: 'zap_report.html'
        }
      }
    }
  }

  post {
    success {
      echo "✅ Build & Push to ECR thành công!"
    }
    failure {
      echo "❌ Pipeline thất bại, kiểm tra lại log."
    }
  }
}



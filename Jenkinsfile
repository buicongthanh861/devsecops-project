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
          sh('kubectl delete all --all -n devsecops || true')
          sh('kubectl apply -f deployment.yaml --namespace devsecops')
        }
      }
    }

    stage('Wait for Testing') {
      steps {
        sh 'pwd'
        sleep 180
        echo "Application has been deployed on k8s"
      }
    }

    stage('Run DAST Using ZAP') {
      steps {
        script {
          withKubeConfig([credentialsId: 'kubelogin']) {
            // Lấy hostname từ service k8s
            def target = sh(
              script: "kubectl get svc asg-service -n devsecops -o json | jq -r '.status.loadBalancer.ingress[0].hostname'",
              returnStdout: true
            ).trim()

            // Chạy OWASP ZAP scan bằng Docker image chính thức
            sh """
            docker run --rm -v ${WORKSPACE}:/zap/wrk/:rw \
              ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
              -t http://${target} \
              -r zap_report.html
            """
          }

          // Lưu report vào Jenkins artifact
          archiveArtifacts artifacts: 'zap_report.html'
        }
      }
    }
  }

  post {
    success {
      echo "✅ Build, Push & Security Scans hoàn tất thành công!"
    }
    failure {
      echo "❌ Pipeline thất bại, vui lòng kiểm tra lại log chi tiết!"
    }
  }
}

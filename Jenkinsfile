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
        sh '''
        pwd
        sleep 180
        echo " Application has been deployed on Kubernetes"
        '''
      }
    }

    stage('Run DAST Using ZAP') {
      steps {
        script {
          // Lấy hostname của service trên Kubernetes
          def targetUrl = sh(
            script: "kubectl get svc asg-service -n devsecops -o json | jq -r '.status.loadBalancer.ingress[] | .hostname'",
            returnStdout: true
          ).trim()

          echo " Running OWASP ZAP DAST scan on: http://${targetUrl}"

          // Chạy ZAP scan bằng Docker image chính thức
          sh """
          docker run --rm -v ${WORKSPACE}:/zap/wrk owasp/zap2docker-stable \
            zap-baseline.py -t http://${targetUrl} -r zap_report.html
          """

          // Lưu báo cáo kết quả vào Jenkins artifact
          archiveArtifacts artifacts: 'zap_report.html'
        }
      }
    }
  }

  post {
    success {
      echo " Build, Deploy & DAST Scan completed successfully!"
    }
    failure {
      echo " Pipeline thất bại, kiểm tra lại log."
    }
  }
}

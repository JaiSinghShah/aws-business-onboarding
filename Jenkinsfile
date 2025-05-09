pipeline {
  agent any

  tools {
    terraform 'Terrform' // This must match the Terraform tool name in Jenkins
  }

  environment {
    AWS_DEFAULT_REGION = 'ap-south-1'
    PATH = "${tool 'Terrform'};${env.PATH}"
  }

  stages {
    stage('Checkout Terraform Code') {
      steps {
        git(
          url: 'https://github.com/JaiSinghShah/aws-business-onboarding.git',
          branch: 'main',
          credentialsId: 'aws-business-onboarding'
        )
      }
    }

    stage('Terraform Init') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'aws-creds',
          usernameVariable: 'AWS_ACCESS_KEY_ID',
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          bat 'terraform init'
        }
      }
    }

    stage('Terraform Destroy') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'aws-creds',
          usernameVariable: 'AWS_ACCESS_KEY_ID',
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          input message: "Are you sure you want to destroy the infrastructure?", ok: "Yes, destroy"
          bat 'terraform destroy -auto-approve -var-file=terraform.tfvars > destroy.log 2>&1'
        }
      }
    }
  }

  post {
    success {
      echo "✅ Terraform destroy completed successfully!"
    }
    failure {
      echo "❌ Terraform destroy failed. Check logs for more details."
    }
    always {
      // Archive the destroy logs
      archiveArtifacts artifacts: 'destroy.log', allowEmptyArchive: true
    }
  }
}

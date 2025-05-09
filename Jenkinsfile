pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = 'ap-south-1'
  }

  stages {
    stage('Checkout Terraform Code') {
      steps {
        // Pull from Git using credential ID 'aws-business-onboarding'
        git(
          url: 'https://github.com/JaiSinghShah/aws-business-onboarding.git',
          branch: 'main',
          credentialsId: 'aws-business-onboarding'
        )
      }
    }

    stage('Terraform Init') {
      steps {
        // Inject AWS creds into env for Terraform
        withCredentials([usernamePassword(
          credentialsId: 'aws-creds',
          usernameVariable: 'AWS_ACCESS_KEY_ID',
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          bat 'terraform init'
        }
      }
    }

    stage('Terraform Validate') {
      steps {
        // Validate the Terraform configuration
        withCredentials([usernamePassword(
          credentialsId: 'aws-creds',
          usernameVariable: 'AWS_ACCESS_KEY_ID',
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          bat 'terraform validate'
        }
      }
    }

    stage('Terraform Destroy') {
      steps {
        // Ask for confirmation before destroying the infrastructure
        withCredentials([usernamePassword(
          credentialsId: 'aws-creds',
          usernameVariable: 'AWS_ACCESS_KEY_ID',
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          input message: "Are you sure you want to destroy the infrastructure?", ok: "Yes, destroy"
          bat 'terraform destroy -auto-approve -var-file=terraform.tfvars'
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
  }
}

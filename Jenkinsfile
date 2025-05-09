pipeline {
  agent any

  environment {
    // Inject AWS credentials stored under ID 'aws-creds'
    AWS_ACCESS_KEY_ID     = credentials('aws-creds').username
    AWS_SECRET_ACCESS_KEY = credentials('aws-creds').password
    AWS_DEFAULT_REGION    = 'ap-south-1'
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
        sh 'terraform init'
      }
    }

    stage('Terraform Validate') {
      steps {
        sh 'terraform validate'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -var-file=terraform.tfvars -out=tfplan.out'
      }
    }

    stage('Terraform Apply') {
      steps {
        // Optional manual confirmation before applying
        input message: "Apply Terraform plan?", ok: "Yes, apply"
        sh 'terraform apply -auto-approve tfplan.out'
      }
    }
  }

  post {
    success {
      echo "✅ Infrastructure deployed successfully!"
    }
    failure {
      echo "❌ Deployment failed—check logs for errors."
    }
    always {
      archiveArtifacts artifacts: '**/*.tf', fingerprint: true
    }
  }
}

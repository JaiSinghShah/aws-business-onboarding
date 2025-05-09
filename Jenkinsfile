pipeline {
    agent any

    tools {
        terraform 'Terraform' // Make sure 'Terraform' tool is configured correctly in Jenkins Global Tool Configuration
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1' // Set the AWS region where your infrastructure resides
        PATH = "${tool 'Terraform'};${env.PATH}" // Ensure the correct Terraform version is used
    }

    stages {
        stage('Checkout Terraform Code') {
            steps {
                git(
                    url: 'https://github.com/JaiSinghShah/aws-business-onboarding.git', // Change the repo URL if necessary
                    branch: 'main',  // Make sure to use the correct branch
                    credentialsId: 'aws-business-onboarding' // Credentials ID for accessing the repository
                )
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds', // Credentials for AWS
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    bat 'terraform init'  // Initialize Terraform
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds', // Credentials for AWS
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    input message: "Are you sure you want to destroy the infrastructure?", ok: "Yes, destroy"
                    bat 'terraform destroy -auto-approve -var-file=terraform.tfvars'  // Perform the destroy operation
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
            archiveArtifacts artifacts: '**/*.tf', allowEmptyArchive: true  // Archive Terraform files if needed for traceability
        }
    }
}

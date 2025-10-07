pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS = credentials('AZURE_CREDENTIALS')
        TF_VAR_admin_password = credentials('TF_VAR_admin_password')
    }

    stages {

        stage('Azure Login') {
            steps {
                script {
                    def creds = readJSON text: AZURE_CREDENTIALS
                    sh """
                    az login --service-principal \
                        -u ${creds.client_id} \
                        -p ${creds.client_secret} \
                        --tenant ${creds.tenant_id}
                    az account set --subscription ${creds.subscription_id}
                    """
                }
            }
        }

        stage('Terraform Init and Plan') {
            steps {
                dir('environments/dev') {
                    sh 'terraform init -upgrade'
                    sh 'terraform plan -var="admin_password=$TF_VAR_admin_password" -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.APPLY_CHANGES == true }
            }
            steps {
                dir('environments/dev') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    parameters {
        booleanParam(name: 'APPLY_CHANGES', defaultValue: false, description: 'Apply Terraform changes automatically')
    }

    post {
        always {
            cleanWs()
        }
    }
}

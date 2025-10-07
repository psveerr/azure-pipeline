# azure-pipeline

    Defining Infrastructure as Code (IaC) with Terraform
    The foundation of the deployment is established using HashiCorp Terraform to define and provision the necessary Azure resources.

Configuration Structure
To ensure scalability and maintainability, the repository should adhere to a specific structure: Repository Root contains the Jenkinsfile, azure-pipelines.yml, and global configuration files like versions.tf. The Environments Directory houses separate, isolated folders for each deployment environment, such as environments/dev and environments/prod. Each environment folder contains its own variable file and main configuration, allowing for unique settings like size or capacity per environment. The Modules Directory contains reusable blocks of Terraform code, for instance, modules/vnet or modules/app_service. This promotes the DRY (Don't Repeat Yourself) principle and ensures consistency across environments.

<img width="1814" height="1008" alt="Screenshot from 2025-10-07 17-15-55" src="https://github.com/user-attachments/assets/d4027bd1-a14b-4d11-b35b-e552c1bb476f" />
<img width="1814" height="1008" alt="Screenshot from 2025-10-07 17-23-55" src="https://github.com/user-attachments/assets/f3f6b37a-0e27-493b-a116-4e9695a5693f" />





Certificate Lifecycle Management
Certificates can be provisioned and managed in several ways: Azure Managed Certificates, which simplify automation by allowing the platform to automatically provision and manage free certificates for Azure App Services. For custom domains or higher security requirements, the certificate file (PFX format) can be stored securely in Azure Key Vault. The Terraform configuration is then granted access to the Key Vault secret, allowing the application gateway, load balancer, or web app to retrieve the certificate at runtime or deployment time. Alternatively, Terraform Provisioning can be used to generate the necessary resources, such as Let's Encrypt certificates via ACME providers, and wire them into the final resource.

<img width="1215" height="485" alt="Screenshot from 2025-10-07 18-18-40" src="https://github.com/user-attachments/assets/fa993e8b-9cb4-4d57-bd25-82549b085a5f" />
<img width="1215" height="485" alt="Screenshot from 2025-10-07 18-26-00" src="https://github.com/user-attachments/assets/b0bd5293-a706-442f-8ad8-86b172eeea9e" />
<img width="1801" height="968" alt="Screenshot from 2025-10-07 18-27-02" src="https://github.com/user-attachments/assets/25c7244e-183d-4433-8d1c-b0615cc77fd9" />

<img width="1814" height="1008" alt="Screenshot from 2025-10-07 17-24-57" src="https://github.com/user-attachments/assets/ad904155-48fc-457f-871b-3af298d40e48" />



Triggering the Pipeline
The main branch is treated as the source of truth for deployments. The pipeline should typically be triggered by a commit or pull request merge to the main branch for automatic plan and validation, and by a manual execution for the final apply step.



Separation of Duties (Plan vs. Apply)
For security and control, the pipeline must strictly separate the planning and application phases. The Plan Phase runs terraform init, validate, and plan. The output, the tfplan file, is stored as an artifact for review. The Apply Phase only executes terraform apply using the pre-approved tfplan file. This phase must be protected by a mandatory manual approval or a parameter check.

    Implementation in Jenkins
    Configuration and Credentials
    Jenkins is set up as a controller node, requiring the Pipeline Utility Steps Plugin to parse credentials and the necessary Git and Azure CLI tools. For Azure Authentication, the Azure Service Principal details (Client ID, Secret, Tenant ID, Subscription ID) are securely stored in Jenkins using the Credentials Manager as a single JSON "Secret Text" credential. The Groovy script reads and uses these variables to execute the az login --service-principal command. Other Secrets, like administrator passwords for virtual machines, are also stored as "Secret Text" credentials and masked during logging.

Jenkins Pipeline Flow
The Groovy-based Jenkinsfile orchestrates the steps. Environment Setup defines all secrets using credentials(). The Azure Login Stage uses the script block to authenticate with Azure CLI via the service principal. The Terraform Init Stage runs terraform init -upgrade within the designated environment subdirectory, environments/dev. The Terraform Plan Stage runs terraform plan -out=tfplan, creating a deterministic plan file. The Terraform Apply Stage is protected by the when condition, which checks a user-provided boolean parameter, APPLY_CHANGES. If true, it runs terraform apply -auto-approve tfplan.

<img width="1801" height="968" alt="Screenshot from 2025-10-07 19-02-06" src="https://github.com/user-attachments/assets/3e7cc5d0-67d8-417e-8a2d-01f9d0df19d5" />
<img width="1799" height="964" alt="Screenshot from 2025-10-07 19-44-19" src="https://github.com/user-attachments/assets/a11b891f-294c-45b1-8e9d-74b7b84b65e7" />
<img width="1799" height="964" alt="Screenshot from 2025-10-07 19-44-37" src="https://github.com/user-attachments/assets/95acd747-31a4-4c78-abc5-882d3c2e9d2c" />







    Implementation in Azure Pipelines
    Configuration and Service Connections
    Azure Pipelines uses a declarative YAML file, azure-pipelines.yml, and relies on native Azure DevOps features for authentication. The Service Connection manages authentication through an Azure Resource Manager Service Connection created in Project Settings. This named connection, such as meowmeow, holds the Service Principal details and permissions, replacing the manual JSON credential management used in Jenkins. Variables like the admin password are stored as Pipeline Secret Variables, allowing them to be safely passed to the Terraform commands.

Azure Pipelines YAML Flow
The YAML file defines separate stages that can be run on a Linux-based agent. The PrepareAndPlan Stage uses the TerraformInstaller task to ensure the correct version is available, uses the AzureCLI task referencing the Service Connection name to perform the login, and runs terraform init, validate, and plan, generating the tfplan artifact. The DeploymentApproval Stage is a manual gate, typically linked to an Azure Pipelines Environment that has a configured Approval Check. This feature strictly enforces that a designated team member must manually review the plan output before the deployment can proceed. The ApplyDeployment Stage only runs if the previous stages succeeded and approval is granted, and runs terraform apply -auto-approve tfplan, executing the pre-approved infrastructure changes.

<img width="498" height="964" alt="Screenshot from 2025-10-07 20-05-45" src="https://github.com/user-attachments/assets/00023fcd-242e-4929-ac00-d74ded967aa4" />
<img width="1856" height="930" alt="Screenshot from 2025-10-07 20-21-56" src="https://github.com/user-attachments/assets/545371ff-090e-40a1-b575-bd7db4ce8243" />

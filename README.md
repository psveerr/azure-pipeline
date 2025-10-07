# azure-pipeline

    Defining Infrastructure as Code (IaC) with Terraform
    The foundation of the deployment is established using HashiCorp Terraform to define and provision the necessary Azure resources.

Configuration Structure
To ensure scalability and maintainability, the repository should adhere to a specific structure: Repository Root contains the Jenkinsfile, azure-pipelines.yml, and global configuration files like versions.tf. The Environments Directory houses separate, isolated folders for each deployment environment, such as environments/dev and environments/prod. Each environment folder contains its own variable file and main configuration, allowing for unique settings like size or capacity per environment. The Modules Directory contains reusable blocks of Terraform code, for instance, modules/vnet or modules/app_service. 


<img width="256" height="652" alt="Screenshot from 2025-10-07 16-53-44" src="https://github.com/user-attachments/assets/bddf24e4-48b8-4d2f-a76a-512f092e55cb" />
<img width="1814" height="1008" alt="Screenshot from 2025-10-07 17-15-55" src="https://github.com/user-attachments/assets/d74edbe6-b88e-4904-b276-c4e8a3900166" />
<img width="1814" height="1008" alt="Screenshot from 2025-10-07 17-23-55" src="https://github.com/user-attachments/assets/81303319-0994-40aa-92dc-e1c1cf31410c" />
<img width="1814" height="1008" alt="Screenshot from 2025-10-07 17-23-55" src="https://github.com/user-attachments/assets/77db8622-7d85-41ef-8022-a4c44f6e867a" />





Certificate Lifecycle Management
Certificates can be provisioned and managed in several ways: Azure Managed Certificates, which simplify automation by allowing the platform to automatically provision and manage free certificates for Azure App Services. For custom domains or higher security requirements, the certificate file (PFX format) can be stored securely in Azure Key Vault. The Terraform configuration is then granted access to the Key Vault secret, allowing the application gateway, load balancer, or web app to retrieve the certificate at runtime or deployment time. Alternatively, Terraform Provisioning can be used to generate the necessary resources, such as Let's Encrypt certificates via ACME providers, and wire them into the final resource.

<img width="1215" height="485" alt="Screenshot from 2025-10-07 18-18-40" src="https://github.com/user-attachments/assets/beaf28ca-dd0e-4681-9202-4d7c7466d7ab" />
<img width="1215" height="485" alt="Screenshot from 2025-10-07 18-26-00" src="https://github.com/user-attachments/assets/6eaa0e15-f7d8-4c3b-8b0c-ad401e87c59b" />
<img width="1801" height="968" alt="Screenshot from 2025-10-07 18-27-02" src="https://github.com/user-attachments/assets/59215a8d-1333-40fc-a8cc-e0c5aa2e6181" />



Triggering the Pipeline
The main branch is treated as the source of truth for deployments. The pipeline should typically be triggered by a commit or pull request merge to the main branch for automatic plan and validation, and by a manual execution for the final apply step.



Separation of Duties (Plan vs. Apply)
For security and control, the pipeline must strictly separate the planning and application phases. The Plan Phase runs terraform init, validate, and plan. The output, the tfplan file, is stored as an artifact for review. The Apply Phase only executes terraform apply using the pre-approved tfplan file. This phase must be protected by a mandatory manual approval or a parameter check.

    Implementation in Jenkins
    Configuration and Credentials
    Jenkins is set up as a controller node, requiring the Pipeline Utility Steps Plugin to parse credentials and the necessary Git and Azure CLI tools. For Azure Authentication, the Azure Service Principal details (Client ID, Secret, Tenant ID, Subscription ID) are securely stored in Jenkins using the Credentials Manager as a single JSON "Secret Text" credential. The Groovy script reads and uses these variables to execute the az login --service-principal command. Other Secrets, like administrator passwords for virtual machines, are also stored as "Secret Text" credentials and masked during logging.

Jenkins Pipeline Flow
The Groovy-based Jenkinsfile orchestrates the steps. Environment Setup defines all secrets using credentials(). The Azure Login Stage uses the script block to authenticate with Azure CLI via the service principal. The Terraform Init Stage runs terraform init -upgrade within the designated environment subdirectory, environments/dev. The Terraform Plan Stage runs terraform plan -out=tfplan, creating a deterministic plan file. The Terraform Apply Stage is protected by the when condition, which checks a user-provided boolean parameter, APPLY_CHANGES. If true, it runs terraform apply -auto-approve tfplan.
<img width="1801" height="968" alt="Screenshot from 2025-10-07 19-02-06" src="https://github.com/user-attachments/assets/9177626f-dc14-438c-a48e-b2a464ad7266" />
<img width="233" height="435" alt="Screenshot from 2025-10-07 19-19-45" src="https://github.com/user-attachments/assets/5abdc9e1-2f84-482e-ab6c-00fe8d5475ce" />
<img width="1799" height="964" alt="Screenshot from 2025-10-07 19-44-19" src="https://github.com/user-attachments/assets/3506cb83-acee-4d2e-b3fa-dd805578e3fc" />
<img width="1799" height="964" alt="Screenshot from 2025-10-07 19-44-37" src="https://github.com/user-attachments/assets/f94d37c5-6dfb-4719-b43b-25b03b8cd930" />
<img width="1799" height="964" alt="Screenshot from 2025-10-07 19-45-14" src="https://github.com/user-attachments/assets/bb6ed24b-0e07-495d-8c1f-e5c80de2b283" />







    Implementation in Azure Pipelines
    Configuration and Service Connections
    Azure Pipelines uses a declarative YAML file, azure-pipelines.yml, and relies on native Azure DevOps features for authentication. The Service Connection manages authentication through an Azure Resource Manager Service Connection created in Project Settings. This named connection, such as meowmeow, holds the Service Principal details and permissions, replacing the manual JSON credential management used in Jenkins. Variables like the admin password are stored as Pipeline Secret Variables, allowing them to be safely passed to the Terraform commands.

Azure Pipelines YAML Flow
The YAML file defines separate stages that can be run on a Linux-based agent. The PrepareAndPlan Stage uses the TerraformInstaller task to ensure the correct version is available, uses the AzureCLI task referencing the Service Connection name to perform the login, and runs terraform init, validate, and plan, generating the tfplan artifact. The DeploymentApproval Stage is a manual gate, typically linked to an Azure Pipelines Environment that has a configured Approval Check. This feature strictly enforces that a designated team member must manually review the plan output before the deployment can proceed. The ApplyDeployment Stage only runs if the previous stages succeeded and approval is granted, and runs terraform apply -auto-approve tfplan, executing the pre-approved infrastructure changes.

<img width="1856" height="930" alt="Screenshot from 2025-10-07 20-21-56" src="https://github.com/user-attachments/assets/f05b8af4-9d59-48f6-a08e-8794e53c4c8b" />
<img width="498" height="964" alt="Screenshot from 2025-10-07 20-05-45" src="https://github.com/user-attachments/assets/27bdbdf5-a725-410e-8945-a69aa856482c" />


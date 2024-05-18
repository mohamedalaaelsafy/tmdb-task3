
# Project Documentation

This repository contains the code and configurations for automating infrastructure provisioning and application deployment using Terraform, Helm, and GitHub Actions.

## Project Structure

- **application:** Contains the project's application code.
- **terraform:**
  - **modules:** Terraform modules for infrastructure provisioning (e.g., installing ArgoCD, configuring Ingress).
  - **envs:** Environment-specific directory configurations (e.g., 'int' for integration environment).
- **helm:**
  - **base-chart:** Base Helm chart for all microservices.
  - **apps-chart:** Helm charts for individual microservices, built upon the base chart in our case we have only `tmdb app`.
- **.github/workflows:** GitHub Actions workflows for automating infrastructure deployment.

## Workflow Steps

1. **GitHub Workflow Trigger:**
   - Run the GitHub workflow and select the desired environment (int/prod).

2. **GitHub Action Execution:**
   - Authenticate with Google and apply Terraform configurations based on the chosen environment.

3. **Terraform Infrastructure Deployment:**
   - Create network-related resources.
   - Deploy a zonal Kubernetes cluster.
   - Install ArgoCD and configure NGINX Ingress.

4. **ArgoCD Application Sync:**
   - Automatically sync and deploy microservices from `./helm/app-charts/` which contain our deployments (eg: frontend/backend) to our `cluster`.

## Tmdb App and ArgoCD Domains

- **Tmdb App URL:** http://tmdb.ma-devops.com
- **ArgoCD URL:** http://argocd.ma-devops.com

## tmdb-app Details

The `tmdb-app` includes the following:
- **Ingress Resource:** An Ingress resource is configured to expose the tmdb-app to external traffic.
- **Service:** Kubernetes Service for the tmdb-app deployment.
- **Deployment:** Deployment configuration for tmdb-app.
- **Health Checks:** Health checks are implemented for ensuring the availability and reliability of the tmdb-app.
All these resources are considered in the `helm base chart`.



## Infrastructure Instructions

1. **Clone the Repository:**


2. **Navigate to Terraform Directory:**

3. **Run GitHub Workflow:**
- Add changes to infrastructure `cd ./terraform` and push your changes.

4. **Select Environment:**
- Choose the environment (int/prod) for infrastructure deployment.

5. **Follow Action Logs:**
- Monitor GitHub Action logs for execution details.

6. **Verify Deployment:**
- Check cloud provider console for infrastructure resources.
- Access ArgoCD and Ingress endpoints for validation.

7. **Test Application Deployment:**
- Verify microservices deployment in Kubernetes.

## Deployments Instructions

1. **Clone the Repository:**


2. **Navigate to your Directory:** 
- `cd ./helm/app-charts/tmdb`
- Add your changes push to repo. 


3. **Sync:**
- the deployemnt will sync automatically with the power of `ArgoCD tool`.

## Cluster Connection and ArgoCD Credentials

- **Cluster Connection Details:**
  - To connect to the GCP Kubernetes cluster, use the appropriate authentication method: `gcloud container clusters get-credentials tmdb-int-cluster \
    --region=us-central-1 --project hamzahllc-technical-task`.
  - Ensure that you have the necessary permissions to interact with the cluster.

- **ArgoCD Username and Password:**
  - To get the `admin` password you can run `kubectl -n argocd get secret argocd-initial-admin-secret \
          -o jsonpath="{.data.password}" | base64 -d; echo`.
    
## Additional Notes

- These tasks are intended for technical evaluation purposes and should be managed with best practices in production environments.

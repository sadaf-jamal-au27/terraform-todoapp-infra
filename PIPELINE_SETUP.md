# Terraform Infrastructure Pipeline Setup

This document provides comprehensive setup instructions for the Terraform CI/CD pipeline for the TodoApp infrastructure.

## 🚀 Pipeline Overview

The pipeline includes the following stages:

1. **Validation**: Format check, init, validate, and security scan
2. **Plan**: Generate Terraform plan for pull requests
3. **Apply**: Deploy to dev/prod environments based on branch
4. **Notification**: Success/failure notifications

## 📋 Prerequisites

### 1. GitHub Repository Secrets

Configure the following secrets in your GitHub repository:

**Go to**: Repository → Settings → Secrets and variables → Actions

#### Required Secrets:
- `AZURE_CLIENT_ID`: Application (client) ID from Azure AD App Registration
- `AZURE_TENANT_ID`: Directory (tenant) ID from Azure AD App Registration  
- `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID
- `SQL_ADMIN_PASSWORD`: SQL Server administrator password

### 2. GitHub Environments

Create the following environments in your repository:

**Go to**: Repository → Settings → Environments

#### Dev Environment:
- Name: `dev`
- Protection rules: None (for automatic deployment)

#### Production Environment:
- Name: `production`
- Protection rules: Required reviewers (recommended)

## 🔧 Azure Setup

### 1. Azure AD App Registration

Follow the detailed guide in `AZURE_SETUP_GUIDE.md` to:
- Create App Registration
- Configure API permissions
- Generate client secret
- Set up OIDC authentication

### 2. Required Azure Permissions

The service principal needs these permissions:
- `Contributor` role on the subscription or resource groups
- `User Access Administrator` role (if managing RBAC)

## 🌿 Branch Strategy

The pipeline uses the following branch strategy:

- **`develop`** → Triggers deployment to **Dev** environment
- **`main`** → Triggers deployment to **Production** environment
- **Pull Requests** → Runs validation and plan only

## 📁 Pipeline Structure

```
.github/workflows/
└── dhondhu.yaml          # Main pipeline file

environments/
├── dev/
│   ├── main.tf          # Dev environment configuration
│   └── provider.tf      # Dev provider configuration
└── prod/
    ├── main.tf          # Prod environment configuration
    └── provider.tf      # Prod provider configuration

modules/
└── [various modules]    # Reusable Terraform modules
```

## 🔄 Pipeline Jobs

### 1. terraform-validate
- **Triggers**: All pushes and PRs
- **Actions**: Format check, init, validate, security scan
- **Purpose**: Ensure code quality and security

### 2. terraform-plan
- **Triggers**: Pull requests only
- **Actions**: Generate Terraform plan
- **Purpose**: Preview changes before merge

### 3. terraform-apply-dev
- **Triggers**: Push to `develop` branch
- **Actions**: Deploy to dev environment
- **Purpose**: Automatic dev deployment

### 4. terraform-apply-prod
- **Triggers**: Push to `main` branch
- **Actions**: Deploy to production environment
- **Purpose**: Production deployment

### 5. notify-success/notify-failure
- **Triggers**: After apply jobs complete
- **Actions**: Send notifications
- **Purpose**: Status updates

## 🛠️ Customization

### Environment-Specific Configuration

Each environment (`dev`, `prod`) has its own configuration:

- **Resource naming**: Different prefixes (dev vs prod)
- **VM sizes**: Smaller for dev, larger for prod
- **Database size**: 2GB for dev, 10GB for prod
- **Tags**: Environment-specific tagging

### Adding New Environments

To add a new environment (e.g., `staging`):

1. Create `environments/staging/` directory
2. Copy and modify `main.tf` and `provider.tf`
3. Add new job in pipeline workflow
4. Configure GitHub environment

### Modifying Pipeline Triggers

Update the `on:` section in the workflow:

```yaml
on:
  push:
    branches: [ main, develop, staging ]  # Add new branches
    paths:
      - 'environments/**'
      - 'modules/**'
      - '.github/workflows/**'
```

## 🔍 Monitoring and Troubleshooting

### Pipeline Status
- Check GitHub Actions tab for pipeline status
- Review logs for detailed error information
- Monitor environment protection rules

### Common Issues

1. **Authentication Errors**
   - Verify Azure secrets are correctly set
   - Check App Registration permissions
   - Ensure subscription ID is correct

2. **Terraform Errors**
   - Review Terraform validation output
   - Check resource naming conflicts
   - Verify Azure resource limits

3. **Environment Protection**
   - Ensure required reviewers are available
   - Check environment protection rules
   - Verify branch protection settings

## 📊 Security Features

- **tfsec**: Security scanning for Terraform code
- **Environment protection**: Manual approval for production
- **Secret management**: Secure handling of sensitive data
- **OIDC**: Passwordless authentication with Azure

## 🚀 Getting Started

1. **Set up Azure App Registration** (see `AZURE_SETUP_GUIDE.md`)
2. **Configure GitHub secrets** (see Prerequisites section)
3. **Create GitHub environments** (see Prerequisites section)
4. **Push to develop branch** to trigger first deployment
5. **Create pull request** to test validation and planning
6. **Merge to main** to deploy to production

## 📞 Support

For issues or questions:
- Check GitHub Actions logs
- Review Terraform documentation
- Consult Azure documentation
- Contact DevOps team

---

**Note**: This pipeline is designed for the TodoApp infrastructure. Modify configurations as needed for your specific requirements.

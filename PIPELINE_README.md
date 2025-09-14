# TodoApp Infrastructure Pipeline

This GitHub Actions pipeline automates the deployment and management of the TodoApp infrastructure on Azure using Terraform.

## 🚀 Pipeline Overview

The pipeline consists of three main jobs:
- **terraform-init-plan**: Validates and plans infrastructure changes
- **terraform-apply**: Deploys infrastructure to Azure
- **terraform-destroy**: Removes all infrastructure resources

## 🔧 Configuration

### Custom Runner
The pipeline uses your custom runner `sadaf-runner` for execution.

### Azure Configuration
- **Credentials**: Configured in GitHub repository settings
- **Authentication**: Uses OpenID Connect with Azure
- **Subscription**: Automatically detected from GitHub settings

### GitHub Settings Required
Ensure the following are configured in your GitHub repository settings:
- **Azure AD App Registration** with appropriate permissions
- **OpenID Connect** configured in Azure AD
- **Repository Secrets** or **Environment Secrets** for Azure authentication
- **Environment Protection Rules** for the `dev` environment

## 📋 Trigger Events

### Automatic Triggers
- **Pull Request**: Runs plan job to validate changes
- **Push to main**: Runs plan and apply jobs

### Manual Triggers
Use `workflow_dispatch` with these options:
- **plan**: Run terraform plan only
- **apply**: Run terraform plan and apply
- **destroy**: Run terraform destroy

## 🏗️ Infrastructure Components

The pipeline deploys:
- **Resource Groups**: `rg-dev-todoapp`, `rg-dev-todoapp-1`
- **Container Registry**: `acrdevtodoapp[random-suffix]` (Premium SKU)
- **Kubernetes Cluster**: `aks-dev-todoapp` (Standard_B2s nodes)
- **SQL Server**: `sql-dev-todoapp-[random-suffix]` (SQL Server 2019)
- **SQL Database**: `sqldb-dev-todoapp` (S0 tier)
- **Public IP**: `pip-dev-todoapp` (Standard SKU)

## 🔒 Security Features

- Uses OpenID Connect for Azure authentication
- Requires `dev` environment approval for apply/destroy operations
- Sensitive data (passwords) marked as sensitive in Terraform
- Random suffixes for globally unique resource names

## 📊 Pipeline Features

### Plan Job
- Terraform format check
- Terraform validation
- Terraform plan with output file
- PR comments with plan results

### Apply Job
- Automatic approval for main branch
- Detailed deployment summary
- Next steps guidance

### Destroy Job
- Manual trigger only
- Complete infrastructure cleanup
- Destruction confirmation

## 🚀 Usage

### Running the Pipeline

1. **Automatic**: Push changes to trigger plan/apply
2. **Manual**: Go to Actions → TodoApp Infrastructure Pipeline → Run workflow
3. **PR**: Create pull request to see plan results

### Manual Operations

```bash
# Plan only
gh workflow run "TodoApp Infrastructure Pipeline" -f action=plan

# Apply infrastructure
gh workflow run "TodoApp Infrastructure Pipeline" -f action=apply

# Destroy infrastructure
gh workflow run "TodoApp Infrastructure Pipeline" -f action=destroy
```

## 📝 Outputs

The pipeline provides:
- Terraform plan results in PR comments
- Deployment summaries in job outputs
- Infrastructure details and next steps
- Error handling with detailed logs

## 🔧 Customization

To modify the pipeline:
1. Update `.github/workflows/dhondhu.yaml`
2. Adjust Azure credentials if needed
3. Modify resource configurations in `environments/dev/`
4. Update runner configuration if required

## 📞 Support

For issues or questions:
- Check the Actions tab for detailed logs
- Review Terraform state and configuration
- Verify Azure permissions and quotas

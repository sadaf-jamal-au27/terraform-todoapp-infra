# Azure OIDC Setup Guide - Production Ready

This guide provides complete production-ready configuration for Azure authentication using OpenID Connect (OIDC).

## 🔐 Azure AD App Registration Setup

### Step 1: Create App Registration in Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to **Azure Active Directory** → **App registrations**
3. Click **"New registration"**
4. Fill in the details:
   - **Name**: `GitHub-Actions-TodoApp`
   - **Supported account types**: `Accounts in this organizational directory only`
   - **Redirect URI**: Leave blank for now
5. Click **"Register"**

### Step 2: Configure App Registration

#### Get Application (Client) ID:
1. Copy the **Application (client) ID** - this is your `AZURE_CLIENT_ID`
2. Copy the **Directory (tenant) ID** - this is your `AZURE_TENANT_ID`

#### Configure API Permissions:
1. Go to **API permissions**
2. Click **"Add a permission"**
3. Select **"Microsoft Graph"**
4. Choose **"Application permissions"**
5. Add these permissions:
   - `Application.ReadWrite.All`
   - `Directory.ReadWrite.All`
6. Click **"Add permissions"**
7. Click **"Grant admin consent"**

#### Create Client Secret:
1. Go to **Certificates & secrets**
2. Click **"New client secret"**
3. **Description**: `GitHub Actions Secret`
4. **Expires**: `24 months` (or your preference)
5. Click **"Add"**
6. **IMPORTANT**: Copy the secret value immediately - this is your `AZURE_CLIENT_SECRET`

## 🔧 GitHub Repository Configuration

### Step 1: Add Repository Secrets

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**

Add these secrets:

#### Secret 1:
- **Name**: `AZURE_CLIENT_ID`
- **Value**: `[Your Application (client) ID from Step 2]`

#### Secret 2:
- **Name**: `AZURE_TENANT_ID`
- **Value**: `[Your Directory (tenant) ID from Step 2]`

#### Secret 3:
- **Name**: `AZURE_SUBSCRIPTION_ID`
- **Value**: `8cbf7ca1-02c5-4b17-aa60-0a669dc6f870`

#### Secret 4:
- **Name**: `AZURE_CLIENT_SECRET`
- **Value**: `[Your client secret value from Step 2]`

### Step 2: Configure Federated Credentials (OIDC)

1. Go back to Azure Portal → Your App Registration
2. Go to **Certificates & secrets** → **Federated credentials**
3. Click **"Add credential"**
4. Choose **"GitHub Actions deploying Azure resources"**
5. Fill in the details:
   - **Organization**: `sadaf-jamal-au27`
   - **Repository**: `terraform-todoapp-infra`
   - **Entity type**: `Environment`
   - **Environment name**: `dev`
   - **Name**: `GitHub-Actions-TodoApp-dev`
6. Click **"Add"**

## 📋 Complete JSON Configuration

### Azure App Registration JSON Template:
```json
{
  "appRegistration": {
    "name": "GitHub-Actions-TodoApp",
    "clientId": "[GENERATED_CLIENT_ID]",
    "tenantId": "[YOUR_TENANT_ID]",
    "clientSecret": "[GENERATED_SECRET]",
    "redirectUri": "https://github.com/sadaf-jamal-au27/terraform-todoapp-infra",
    "apiPermissions": [
      "Microsoft.Graph/Application.ReadWrite.All",
      "Microsoft.Graph/Directory.ReadWrite.All",
      "Azure Service Management/user_impersonation"
    ]
  },
  "federatedCredentials": {
    "name": "GitHub-Actions-TodoApp-dev",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:sadaf-jamal-au27/terraform-todoapp-infra:environment:dev",
    "audiences": ["api://AzureADTokenExchange"],
    "description": "GitHub Actions for TodoApp Infrastructure"
  },
  "githubSecrets": {
    "AZURE_CLIENT_ID": "[YOUR_CLIENT_ID]",
    "AZURE_TENANT_ID": "[YOUR_TENANT_ID]",
    "AZURE_SUBSCRIPTION_ID": "8cbf7ca1-02c5-4b17-aa60-0a669dc6f870",
    "AZURE_CLIENT_SECRET": "[YOUR_CLIENT_SECRET]"
  }
}
```

### GitHub Actions Workflow Configuration:
```yaml
permissions:
  id-token: write
  contents: read

jobs:
  infrastructure-plan:
    runs-on: ubuntu-latest
    environment: dev  # This triggers OIDC
    steps:
      - name: Azure Login
        uses: Azure/login@v2.3.0
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          enable-AzPSSession: false
          environment: azurecloud
          allow-no-subscriptions: false
          audience: api://AzureADTokenExchange
```

## 🔒 Production Security Best Practices

### 1. Environment Protection Rules
- Set up environment protection rules in GitHub
- Require manual approval for production deployments
- Restrict deployments to specific branches

### 2. Secret Management
- Rotate secrets regularly (every 90 days)
- Use Azure Key Vault for sensitive application secrets
- Implement secret scanning in CI/CD

### 3. Access Control
- Use least privilege principle
- Regular access reviews
- Monitor and audit access logs

### 4. Monitoring
- Enable Azure Monitor and Application Insights
- Set up alerts for infrastructure changes
- Monitor cost and usage patterns

## 🚀 Deployment Steps

1. **Complete Azure AD setup** (Steps 1-2 above)
2. **Add GitHub secrets** (Step 1 in GitHub section)
3. **Configure OIDC** (Step 2 in GitHub section)
4. **Create dev environment** in GitHub repository settings
5. **Test deployment** with manual workflow dispatch

## 🔍 Troubleshooting

### Common Issues:
- **"Not all values are present"**: Check all secrets are added correctly
- **"Invalid audience"**: Verify OIDC configuration matches exactly
- **"Insufficient permissions"**: Check API permissions and admin consent
- **"Environment not found"**: Create `dev` environment in GitHub settings

### Validation Commands:
```bash
# Check Azure login
az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID

# Test subscription access
az account show --subscription $AZURE_SUBSCRIPTION_ID

# Verify resource group access
az group list --subscription $AZURE_SUBSCRIPTION_ID
```

## 📞 Support

For issues:
1. Check Azure AD App Registration configuration
2. Verify GitHub secrets are correct
3. Ensure OIDC federated credentials match repository
4. Review GitHub Actions logs for detailed error messages

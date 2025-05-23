#!/bin/bash

# Configuration
PROJECT_NAME="litware"
SUBSCRIPTION_NAME="Demo Subscription"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Setting up Azure Service Principal for Terraform...${NC}"

# Get subscription ID
echo "Getting subscription ID..."
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Could not get subscription ID. Please make sure you're logged into Azure CLI.${NC}"
    exit 1
fi

# Get tenant ID
echo "Getting tenant ID..."
TENANT_ID=$(az account show --query tenantId --output tsv)

# Create service principal
echo "Creating service principal..."
SP_JSON=$(az ad sp create-for-rbac --name "sp-${PROJECT_NAME}-terraform" \
    --role "Contributor" \
    --scopes "/subscriptions/${SUBSCRIPTION_ID}" \
    --json)

# Extract values from service principal JSON
CLIENT_ID=$(echo $SP_JSON | jq -r .appId)
CLIENT_SECRET=$(echo $SP_JSON | jq -r .password)

# Create .env file
echo "Creating .env file..."
cat > "$(dirname "$0")/../.env" << EOF
# Azure Authentication
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"
export ARM_TENANT_ID="${TENANT_ID}"
export ARM_CLIENT_ID="${CLIENT_ID}"
export ARM_CLIENT_SECRET="${CLIENT_SECRET}"

# Terraform Backend Storage
export TF_VAR_backend_resource_group_name="rg-terraform-state"
export TF_VAR_backend_storage_account_name="stlitwareterraformdev"
export TF_VAR_backend_container_name="tfstate"

# Project Configuration
export TF_VAR_project_name="${PROJECT_NAME}"
export TF_VAR_environment="dev"
export TF_VAR_location="eastus"

# Tags
export TF_VAR_tags='{
    environment = "dev"
    project     = "litware-energy-ml"
    managedBy   = "terraform"
}'
EOF

echo -e "${GREEN}Environment setup complete!${NC}"
echo -e "${YELLOW}Please run: source ../env to load the environment variables${NC}"

# Display important information
echo -e "\n${GREEN}Important Information:${NC}"
echo -e "Subscription ID: ${YELLOW}${SUBSCRIPTION_ID}${NC}"
echo -e "Tenant ID: ${YELLOW}${TENANT_ID}${NC}"
echo -e "Client ID: ${YELLOW}${CLIENT_ID}${NC}"
echo -e "Client Secret: ${YELLOW}${CLIENT_SECRET}${NC}"
echo -e "\n${RED}Please save these values securely!${NC}"

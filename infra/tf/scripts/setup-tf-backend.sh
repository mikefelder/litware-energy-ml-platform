#!/bin/bash

# Variables
RESOURCE_GROUP_NAME="rg-terraform-state"
STORAGE_ACCOUNT_NAME_DEV="stlitwareterraformdev"
STORAGE_ACCOUNT_NAME_STAGING="stlitwareterraformstg"
STORAGE_ACCOUNT_NAME_PROD="stlitwareterraformprod"
CONTAINER_NAME="tfstate"
LOCATION="eastus"

# Create resource group
echo "Creating resource group..."
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Function to create storage account and container
create_storage_account() {
    local storage_account_name=$1
    echo "Creating storage account: $storage_account_name..."
    
    # Create storage account
    az storage account create \
        --resource-group $RESOURCE_GROUP_NAME \
        --name $storage_account_name \
        --sku Standard_LRS \
        --encryption-services blob \
        --min-tls-version TLS1_2 \
        --allow-blob-public-access false

    # Get storage account key
    ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $storage_account_name --query '[0].value' -o tsv)

    # Create blob container
    echo "Creating blob container..."
    az storage container create \
        --name $CONTAINER_NAME \
        --account-name $storage_account_name \
        --account-key $ACCOUNT_KEY
}

# Create storage accounts for each environment
create_storage_account $STORAGE_ACCOUNT_NAME_DEV
create_storage_account $STORAGE_ACCOUNT_NAME_STAGING
create_storage_account $STORAGE_ACCOUNT_NAME_PROD

echo "Backend setup complete!"

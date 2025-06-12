#!/bin/bash

# Terraform Deployment Script for Litware Energy ML Platform
# This script helps deploy the infrastructure step by step

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
ENV=${1:-dev}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="${SCRIPT_DIR}/../environments/${ENV}"

echo -e "${BLUE}=== Litware Energy ML Platform Terraform Deployment ===${NC}"
echo -e "Environment: ${YELLOW}${ENV}${NC}"
echo -e "Directory: ${YELLOW}${ENV_DIR}${NC}\n"

# Check if environment directory exists
if [ ! -d "$ENV_DIR" ]; then
    echo -e "${RED}Error: Environment directory '${ENV_DIR}' does not exist${NC}"
    echo -e "Available environments:"
    ls -1 "${SCRIPT_DIR}/../environments/" 2>/dev/null || echo "None found"
    exit 1
fi

# Check if .env file exists
if [ ! -f "${SCRIPT_DIR}/../.env" ]; then
    echo -e "${YELLOW}Warning: .env file not found${NC}"
    echo -e "Please create one using the template: cp env.template .env"
    echo -e "Then edit .env with your Azure credentials"
    echo -e "You can also run: ./setup-azure-sp.sh to create one automatically\n"
fi

# Source environment variables if available
if [ -f "${SCRIPT_DIR}/../.env" ]; then
    echo -e "${GREEN}Loading environment variables...${NC}"
    source "${SCRIPT_DIR}/../.env"
fi

# Navigate to environment directory
cd "$ENV_DIR"

echo -e "\n${YELLOW}Step 1: Terraform Init${NC}"
echo -e "Initializing Terraform..."
terraform init

echo -e "\n${YELLOW}Step 2: Terraform Validate${NC}"
echo -e "Validating Terraform configuration..."
terraform validate

echo -e "\n${YELLOW}Step 3: Terraform Plan${NC}"
echo -e "Creating execution plan..."
terraform plan -out=tfplan

echo -e "\n${GREEN}=== Deployment Plan Created Successfully! ===${NC}"
echo -e "\nNext steps:"
echo -e "1. Review the plan above"
echo -e "2. If everything looks good, run: ${YELLOW}terraform apply tfplan${NC}"
echo -e "3. Or run this script with 'apply' argument: ${YELLOW}$0 ${ENV} apply${NC}"

# If apply argument is provided, apply the plan
if [ "$2" = "apply" ]; then
    echo -e "\n${YELLOW}Step 4: Terraform Apply${NC}"
    echo -e "Applying the infrastructure changes..."
    read -p "Are you sure you want to apply these changes? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        terraform apply tfplan
        echo -e "\n${GREEN}=== Deployment Complete! ===${NC}"
    else
        echo -e "${YELLOW}Deployment cancelled.${NC}"
    fi
fi

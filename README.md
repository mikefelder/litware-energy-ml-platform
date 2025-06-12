
# 💡 Litware Energy Co: AI/ML POC Demo Environment

![Terraform](https://img.shields.io/badge/IaC-Terraform-blue?logo=terraform)
![Azure](https://img.shields.io/badge/Cloud-Azure-blue?logo=microsoftazure)
![Status](https://img.shields.io/badge/Status-POC-yellow)

---

## 📚 Table of Contents

- [📌 Purpose](#-purpose)
- [🧭 Vignette Overview](#-vignette-overview)
- [🏗️ Terraform Structure](#️-terraform-structure)
- [🔐 Access & Security](#-access--security)
- [🚀 Getting Started](#-getting-started)
- [📦 Future Enhancements](#-future-enhancements)
- [📝 Notes](#-notes)

# 💡 Litware Energy Co: AI/ML POC Demo Environment

This repository contains the Terraform configuration and scenario vignettes for deploying a Proof of Concept (POC) AI/ML environment tailored to the energy sector.

---

## 📌 Purpose

To demonstrate the capabilities of Azure AI/ML tools in solving real-world energy industry challenges through targeted, persona-driven vignettes.

---

## 🧭 Vignette Overview

| Vignette | Persona | Description | Key Technologies |
|---------|---------|-------------|------------------|
| Predictive Asset Maintenance | Grid Operations Manager | Forecast transformer or turbine failure before outages. | [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/), [Azure Arc](https://learn.microsoft.com/azure/azure-arc/), [Azure Data Explorer](https://learn.microsoft.com/azure/data-explorer/) |
| Carbon Emissions Tracking | Environmental Compliance Officer | Track and forecast CO₂ emissions for reporting and action. | [Azure AI Studio](https://learn.microsoft.com/azure/ai-studio/overview), [Power BI](https://learn.microsoft.com/power-bi/fundamentals/service-overview), [Microsoft Purview](https://learn.microsoft.com/azure/purview/) |
| AI Governance & Cybersecurity | CISO | Secure AI pipelines and enforce compliance. | [Microsoft Entra ID](https://learn.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis), Purview, AI Foundry |
| Real-Time Load Forecasting | Energy Market Analyst | Predict hourly energy demand for bidding and planning. | [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/), [Azure Data Factory](https://learn.microsoft.com/azure/data-factory/), [Power BI](https://learn.microsoft.com/power-bi/fundamentals/service-overview) |
| GenAI for Field Ops | Field Technician | Use a GenAI assistant for troubleshooting in the field. | [Azure OpenAI](https://learn.microsoft.com/azure/ai-services/openai/), [Microsoft Power Platform](https://learn.microsoft.com/power-platform/), [Azure AI Search](https://learn.microsoft.com/azure/search/search-what-is-azure-search) |
| Energy Trading Analytics | Trading Desk Manager | Combine ML and GenAI to guide energy trading decisions. | [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/), [Power BI](https://learn.microsoft.com/power-bi/fundamentals/service-overview), AI Foundry |

---

## 🏗️ Terraform Structure

- **Resource Groups** per vignette and shared services
- **Networking**: Hub & spoke with private endpoints, NSGs
- **Identity**: [Microsoft Entra ID](https://learn.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis) integration
- **ML & Data Services**: [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/) Workspace, Storage, Key Vault
- **RBAC**: Role assignments for users, groups, current owner
- **Users & Groups**: Test Entra ID users with secure credentials

---

## 🔐 Access & Security

- Azure Key Vault for secrets
- RBAC at resource group, ML workspace, and Storage account levels
- Conditional MFA and Just-In-Time access policies recommended

---

## 🚀 Getting Started

1. Set the following variables in `terraform.tfvars`:
    ```hcl
    tenant_domain           = "litwareenergyco.onmicrosoft.com"
    admin_group_object_id   = "<your_admin_group_object_id>"
    ```

2. Run Terraform:
    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

3. Access credentials for test users will be shown in Terraform output:
    ```json
    ml_users_credentials = {
      "mluser1@litwareenergyco.onmicrosoft.com" = "********"
      ...
    }
    ```

---

## 📦 Future Enhancements

- Azure [Azure Data Factory](https://learn.microsoft.com/azure/data-factory/) pipelines
- [Power BI](https://learn.microsoft.com/power-bi/fundamentals/service-overview) Embedded dashboards
- Generative AI service deployments
- Private DNS zones and Bastion host

---

## 📝 Notes

This demo POC is intended for internal evaluation only. Please ensure any real data or user credentials used in production environments follow your organization’s compliance policies.

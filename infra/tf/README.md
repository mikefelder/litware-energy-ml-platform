# README.md content

# Terraform Modules Project

This project is structured to manage Azure resources using Terraform modules. It separates the infrastructure into distinct modules for better organization and reusability.

## Modules

- **identity**: Contains resources related to identity management, such as Azure AD groups and users.
- **rbac**: Manages role-based access control (RBAC) for Azure resources.
- **storage**: Handles the creation and configuration of Azure Storage accounts.

## Environments

The project supports multiple environments:

- **dev**: Development environment configuration.
- **prod**: Production environment configuration.

## Usage

### TODO: Add service principal creation and any other prequisites needed

To deploy the infrastructure, navigate to the desired environment folder (e.g., `environments/dev`) and run the following commands:

```bash
terraform init
terraform apply
```

## Requirements

- Terraform version 1.x or higher
- Azure account with appropriate permissions

## License

This project is licensed under the MIT License. See the LICENSE file for details.
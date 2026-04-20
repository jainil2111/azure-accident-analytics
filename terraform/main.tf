# ============================================================
# Terraform — Azure Accident Analytics Infrastructure
# ============================================================
# Resources:
#   - Resource Group
#   - Storage Account (ADLS Gen2)
#   - Databricks Workspace
#   - SQL Server
#   - SQL Database
# ============================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

# ── Variables ──────────────────────────────────────────────

variable "location" {
  default = "canadacentral"
}

variable "sql_admin_login" {
  default = "sqladmin"
}

variable "sql_admin_password" {
  description = "SQL admin password"
  sensitive   = true
  default     = "TableChair@1"
}

# ── Resource Group ─────────────────────────────────────────

resource "azurerm_resource_group" "main" {
  name     = "data-engineering-project"
  location = var.location

  tags = {
    project = "azure-accident-analytics"
    env     = "college-project"
  }
}

# ── Storage Account (ADLS Gen2) ────────────────────────────

resource "azurerm_storage_account" "main" {
  name                     = "deprojectstorage1"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true  # Enables ADLS Gen2 hierarchical namespace

  tags = {
    project = "azure-accident-analytics"
  }
}

# Raw container
resource "azurerm_storage_container" "raw" {
  name                  = "raw"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Processed container
resource "azurerm_storage_container" "processed" {
  name                  = "processed"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# ── Databricks Workspace ───────────────────────────────────

resource "azurerm_databricks_workspace" "main" {
  name                = "de-project-databricks"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "standard"

  tags = {
    project = "azure-accident-analytics"
  }
}

# ── SQL Server ─────────────────────────────────────────────

resource "azurerm_mssql_server" "main" {
  name                         = "deprojectserver2026"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password

  tags = {
    project = "azure-accident-analytics"
  }
}

# Allow Azure services to access SQL Server
resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# ── SQL Database ───────────────────────────────────────────

resource "azurerm_mssql_database" "main" {
  name      = "de-project-db"
  server_id = azurerm_mssql_server.main.id
  sku_name  = "GP_S_Gen5_1"  # Free tier equivalent (serverless)
  
  auto_pause_delay_in_minutes = 60
  min_capacity                = 0.5

  tags = {
    project = "azure-accident-analytics"
  }
}

# ── Azure Data Factory ─────────────────────────────────────

resource "azurerm_data_factory" "main" {
  name                = "adf-accident-analytics"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = {
    project = "azure-accident-analytics"
  }
}

# ── Outputs ────────────────────────────────────────────────

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.main.workspace_url
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_database_name" {
  value = azurerm_mssql_database.main.name
}

output "data_factory_name" {
  value = azurerm_data_factory.main.name
}

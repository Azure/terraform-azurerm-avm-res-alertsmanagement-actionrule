terraform {
  required_version = "~> 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.21"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  location = "australiaeast"
  name     = "rg-avm-suppression-test"
}

module "test" {
  source = "../../"

  location            = azurerm_resource_group.this.location
  name                = "apr-suppress"
  resource_group_name = azurerm_resource_group.this.name
  rule_type           = "suppression"
  scopes = [
    azurerm_resource_group.this.id
  ]
  conditions = [
    {
      operator = "Equals"
      values   = ["Sev3"]
    }
  ]
  schedule = {
    effective_from  = "2024-01-01T00:00:00"
    effective_until = "2025-01-01T00:00:00"
    time_zone       = "UTC"

    recurrence = {
      daily = {
        start_time = "22:00:00"
        end_time   = "23:00:00"
      }
      weekly = {
        days_of_week = ["Saturday", "Sunday"]
        start_time   = "22:00:00"
        end_time     = "23:00:00"
      }
    }
  }
}

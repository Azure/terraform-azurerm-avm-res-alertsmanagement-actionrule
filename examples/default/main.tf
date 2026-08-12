terraform {
  required_version = "~> 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "this" {
  name     = "rg-avm-actionrule-test"
  location = "australiaeast"
}

# Action Group (required for this rule type)
resource "azurerm_monitor_action_group" "this" {
  name                = "ag-avm-test"
  resource_group_name = azurerm_resource_group.this.name
  short_name          = "avmtest"

  email_receiver {
    name          = "satish"
    email_address = "balakrishnan.satish@hotmail.com"
  }
}

# Module call
module "test" {
  source = "../../"

  name                = "apr-add-ag"
  rule_type           = "action_group"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  scopes = [
    azurerm_resource_group.this.id
  ]

  add_action_group_ids = [
    azurerm_monitor_action_group.this.id
  ]

  conditions = [
    {
      operator = "Equals"
      values   = ["Sev3"]
    }
  ]
}

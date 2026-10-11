mock_provider "azapi" {}

mock_provider "azurerm" {
  mock_resource "azurerm_monitor_alert_processing_rule_action_group" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.AlertsManagement/actionRules/test-action-group-rule"
    }
  }

  mock_resource "azurerm_monitor_alert_processing_rule_suppression" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.AlertsManagement/actionRules/test-suppression-rule"
    }
  }
}

mock_provider "modtm" {}
mock_provider "random" {}

variables {
  location            = "eastus"
  name                = "test-alert-rule"
  resource_group_name = "test-rg"
  scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg"]
  enable_telemetry    = false
}

run "action_group_resource_id" {
  command = apply

  variables {
    rule_type            = "action_group"
    add_action_group_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/actionGroups/test-action-group"]
  }

  assert {
    condition     = output.resource_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.AlertsManagement/actionRules/test-action-group-rule"
    error_message = "resource_id must identify the action-group alert processing rule."
  }

  assert {
    condition     = output.id == output.resource_id
    error_message = "The existing id output must continue to return the same resource ID."
  }
}

run "suppression_resource_id" {
  command = apply

  variables {
    rule_type = "suppression"
    schedule = {
      effective_from  = "2026-01-01T00:00:00"
      effective_until = "2027-01-01T00:00:00"
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

  assert {
    condition     = output.resource_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.AlertsManagement/actionRules/test-suppression-rule"
    error_message = "resource_id must identify the suppression alert processing rule."
  }

  assert {
    condition     = output.id == output.resource_id
    error_message = "The existing id output must continue to return the same resource ID."
  }
}

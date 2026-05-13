output "id" {
  description = "The resource ID of the alert processing rule."
  value       = var.rule_type == "action_group" ? azurerm_monitor_alert_processing_rule_action_group.this[0].id : azurerm_monitor_alert_processing_rule_suppression.this[0].id
}

output "name" {
  description = "The name of the alert processing rule."
  value       = var.rule_type == "action_group" ? azurerm_monitor_alert_processing_rule_action_group.this[0].name : azurerm_monitor_alert_processing_rule_suppression.this[0].name
}

output "resource" {
  description = "The full alert processing rule resource."
  value       = var.rule_type == "action_group" ? azurerm_monitor_alert_processing_rule_action_group.this[0] : azurerm_monitor_alert_processing_rule_suppression.this[0]
}

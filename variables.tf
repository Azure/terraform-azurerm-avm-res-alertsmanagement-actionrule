variable "location" {
  type        = string
  description = "Azure region (kept for AVM consistency)."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the alert processing rule."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the alert processing rule will be deployed."
  nullable    = false
}

variable "rule_type" {
  type        = string
  description = "Type of alert processing rule. Valid values are action_group and suppression."
  nullable    = false

  validation {
    condition     = contains(["action_group", "suppression"], var.rule_type)
    error_message = "rule_type must be either 'action_group' or 'suppression'."
  }
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the alert processing rule."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether the alert processing rule is enabled."
  nullable    = false
}

variable "scopes" {
  type        = list(string)
  description = "List of scopes that the alert processing rule applies to."
  nullable    = false
}

variable "add_action_group_ids" {
  type        = list(string)
  default     = []
  description = "List of Action Group resource IDs to add (used only when rule_type = action_group)."
  nullable    = false
}

variable "conditions" {
  type = list(object({
    operator = string
    values   = list(string)
  }))
  default     = []
  description = "List of severity conditions for the alert processing rule."
  nullable    = false
}

variable "schedule" {
  type = object({
    effective_from  = string
    effective_until = string
    time_zone       = string
    recurrence = object({
      daily = object({
        start_time = string
        end_time   = string
      })
      weekly = object({
        days_of_week = list(string)
        start_time   = string
        end_time     = string
      })
    })
  })
  default     = null
  description = "Schedule configuration for suppression rules (required when rule_type = suppression)."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
DESCRIPTION
  nullable    = false
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = "Optional resource lock configuration."

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "Lock must be CanNotDelete or ReadOnly."
  }
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = "Role assignments to apply to the resource."
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags for the resource."
}

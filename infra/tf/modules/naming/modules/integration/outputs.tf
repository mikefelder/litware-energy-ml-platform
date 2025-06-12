output "eventgrid_domain" {
  value       = local.az.eventgrid_domain
  description = "Naming conventions for Event Grid Domain resources"
}

output "eventgrid_topic" {
  value       = local.az.eventgrid_topic
  description = "Naming conventions for Event Grid Topic resources"
}

output "eventhub_namespace" {
  value       = local.az.eventhub_namespace
  description = "Naming conventions for Event Hub Namespace resources"
}

output "eventhub" {
  value       = local.az.eventhub
  description = "Naming conventions for Event Hub resources"
}

output "servicebus_namespace" {
  value       = local.az.servicebus_namespace
  description = "Naming conventions for Service Bus Namespace resources"
}

output "servicebus_queue" {
  value       = local.az.servicebus_queue
  description = "Naming conventions for Service Bus Queue resources"
}

output "servicebus_topic" {
  value       = local.az.servicebus_topic
  description = "Naming conventions for Service Bus Topic resources"
}

output "naming_rules" {
  description = "Naming rules for integration resources"
  value = {
    api_management = {
      name        = substr(join("-", compact([local.clean_prefix, "apim", local.clean_suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.clean_prefix, "apim", local.clean_suffix, local.random_string])), 0, 50)
      dashes      = true
      slug        = "apim"
      min_length  = 1
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
    service_bus = {
      name        = substr(join("-", compact([local.clean_prefix, "sb", local.clean_suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.clean_prefix, "sb", local.clean_suffix, local.random_string])), 0, 50)
      dashes      = true
      slug        = "sb"
      min_length  = 6
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
    event_hub = {
      name        = substr(join("-", compact([local.clean_prefix, "evh", local.clean_suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.clean_prefix, "evh", local.clean_suffix, local.random_string])), 0, 50)
      dashes      = true
      slug        = "evh"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
  }
}
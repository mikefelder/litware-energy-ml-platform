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
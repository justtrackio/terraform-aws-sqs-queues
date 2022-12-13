output "queue_names" {
  description = "SQS queue names"
  value       = { for k, v in module.queue : k => v.queue_name }
}

output "queue_arns" {
  description = "SQS queue arns"
  value       = { for k, v in module.queue : k => v.queue_arn }
}

output "queue_ids" {
  description = "SQS queue ids"
  value       = { for k, v in module.queue : k => v.queue_id }
}

output "queue_dead_letter_names" {
  description = "SQS dead letter queue names"
  value       = { for k, v in module.dead : k => v.queue_name }
}

output "queue_dead_letter_arns" {
  description = "SQS dead letter queue arns"
  value       = { for k, v in module.dead : k => v.queue_arn }
}

output "queue_dead_letter_ids" {
  description = "SQS dead letter queue id"
  value       = { for k, v in module.dead : k => v.queue_id }
}

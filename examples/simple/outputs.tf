output "queue_arns" {
  description = "SQS queue arns"
  value       = module.queue.queue_arns
}

output "queue_dead_letter_arns" {
  description = "SQS dead letter queue arns"
  value       = module.queue.queue_dead_letter_arns
}

output "queue_dead_letter_ids" {
  description = "SQS dead letter queue id"
  value       = module.queue.queue_dead_letter_ids
}

output "queue_dead_letter_name" {
  description = "SQS dead letter queue names"
  value       = module.queue.queue_dead_letter_names
}

output "queue_ids" {
  description = "SQS queue ids"
  value       = module.queue.queue_ids
}

output "queue_names" {
  description = "SQS queue names"
  value       = module.queue.queue_names
}

variable "alarm_topic_label_order" {
  type        = list(string)
  description = <<-EOT
    The order in which the labels (ID elements) appear in the `id`.
    Defaults to ["namespace", "environment", "stage", "name", "attributes"].
    You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present.
    EOT
  default     = null
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "queues" {
  type = map(object({
    alarm = optional(object({
      create              = optional(bool, false)
      datapoints_to_alarm = optional(number, 3)
      evaluation_periods  = optional(number, 3)
      backlog_minutes     = optional(number, 3)
      period              = optional(number, 60)
      threshold           = optional(number, 0)
    }))
    queue = object({
      dead_letter_queue_create   = optional(bool, true)
      delay_seconds              = optional(number, null)
      fifo_queue                 = optional(bool, false)
      max_receive_count          = optional(number, null)
      message_retention_seconds  = optional(number, null)
      visibility_timeout_seconds = optional(number, null)
    })
    subscriptions = optional(map(object({
      enabled       = optional(bool, true)
      stage         = optional(string, null)
      name          = optional(string, null)
      attributes    = optional(set(string), null)
      filter_policy = optional(string, null)
    })))
  }))
  description = "Queues to be created"
  default     = {}
}

variable "topic_label_order" {
  type        = list(string)
  description = <<-EOT
    The order in which the labels (ID elements) appear in the `id`.
    Defaults to ["namespace", "environment", "stage", "name", "attributes"].
    You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present.
    EOT
  default     = null
}

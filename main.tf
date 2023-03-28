module "queue" {
  source  = "justtrackio/sqs-queue/aws"
  version = "1.4.0"

  for_each = var.queues

  context = module.this.context

  alarm_create                    = each.value.alarm.create
  alarm_minutes                   = each.value.alarm.backlog_minutes
  alarm_period                    = each.value.alarm.period
  alarm_evaluation_periods        = each.value.alarm.evaluation_periods
  alarm_datapoints_to_alarm       = each.value.alarm.datapoints_to_alarm
  alarm_description               = each.value.alarm.description
  alarm_threshold                 = each.value.alarm.threshold
  alarm_topic_arn                 = var.alarm_topic_arn
  aws_account_id                  = var.aws_account_id
  aws_region                      = var.aws_region
  dead_letter_queue_arn           = try(each.value.queue.dead_letter_queue_create, true) ? module.dead[each.key].queue_arn : null
  delay_seconds                   = each.value.queue.delay_seconds
  fifo_queue                      = each.value.queue.fifo_queue
  max_receive_count               = each.value.queue.max_receive_count
  message_retention_seconds       = each.value.queue.message_retention_seconds
  principals_with_send_permission = each.value.queue.principals_with_send_permission
  queue_name                      = try(each.value.queue.fifo_queue, false) ? "${each.key}.fifo" : each.key
  source_arns                     = [for k, v in each.value.subscriptions != null ? each.value.subscriptions : {} : v.topic_arn]
  visibility_timeout_seconds      = each.value.queue.visibility_timeout_seconds
}

module "dead" {
  source  = "justtrackio/sqs-queue/aws"
  version = "1.4.0"

  for_each = { for k, v in var.queues : k => v if v.queue.dead_letter_queue_create }

  context = module.this.context

  aws_region                = var.aws_region
  aws_account_id            = var.aws_account_id
  fifo_queue                = each.value.queue.fifo_queue
  message_retention_seconds = each.value.queue.message_retention_seconds
  queue_name                = try(each.value.queue.fifo_queue, false) ? "${each.key}-dead.fifo" : "${each.key}-dead"
}

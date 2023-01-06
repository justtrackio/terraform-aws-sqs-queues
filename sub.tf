resource "aws_sns_topic_subscription" "main" {
  for_each = merge([for k, v in var.queues : { for ks, s in v.subscriptions != null ? v.subscriptions : {} : "${ks}-${k}" =>
    {
      subscription = s
      queue = {
        arn = module.queue[k].queue_arn
      }
  } if s.enabled }]...)
  topic_arn                       = each.value.subscription.topic_arn
  confirmation_timeout_in_minutes = "1"
  endpoint_auto_confirms          = "false"
  protocol                        = "sqs"
  endpoint                        = each.value.queue.arn
  filter_policy                   = each.value.subscription.filter_policy
}

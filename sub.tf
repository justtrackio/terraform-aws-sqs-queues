locals {
  subscriptions = merge([for v in var.queues : { for subKey, s in v.subscriptions != null ? v.subscriptions : {} : subKey => s if s.enabled }]...)
}

module "topic_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  for_each = local.subscriptions

  context     = module.this.context
  label_order = var.topic_label_order

  stage      = each.value.stage
  name       = each.value.name
  attributes = each.value.attributes
}

data "aws_sns_topic" "topic" {
  provider = aws.topic_owner
  for_each = local.subscriptions
  name     = module.topic_label[each.key].id
}

resource "aws_sns_topic_subscription" "main" {
  for_each = merge([for k, v in var.queues : { for ks, s in v.subscriptions != null ? v.subscriptions : {} : ks =>
    {
      subscription = s
      queue = {
        arn = module.queue[k].queue_arn
      }
  } if s.enabled }]...)
  topic_arn                       = data.aws_sns_topic.topic[each.key].arn
  confirmation_timeout_in_minutes = "1"
  endpoint_auto_confirms          = "false"
  protocol                        = "sqs"
  endpoint                        = each.value.queue.arn
  filter_policy                   = each.value.subscription.filter_policy
}

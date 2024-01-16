locals {
  namespace   = "namespace"
  environment = "environment"
  stage       = "stage"
  topics = {
    "s-n-attribute1" = {
      stage      = "stage"
      name       = "name"
      attributes = ["attribute1"]
    }
    "s-n-attribute2" = {
      stage      = "stage"
      name       = "name"
      attributes = ["attribute2"]
    }
  }
  subscriptions = {
    "s-n-attribute1" = {
      enabled   = true
      topic_arn = module.topic["s-n-attribute1"].topic_arn
    }
    "s-n-attribute2" = {
      enabled   = true
      topic_arn = module.topic["s-n-attribute2"].topic_arn
    }
  }
}

module "topic" {
  source  = "justtrackio/sns-topic/aws"
  version = "1.6.0"

  for_each = local.topics

  providers = {
    aws = aws.topic_owner
  }

  principals_with_subscribe_permission = [
    "arn:aws:iam::123456789123:root"
  ]

  alarm_enabled = false
  namespace     = local.namespace
  environment   = local.environment
  stage         = each.value.stage
  name          = each.value.name
  attributes    = each.value.attributes
}

module "queue" {
  source = "../.."
  providers = {
    aws             = aws
    aws.topic_owner = aws.topic_owner
  }

  depends_on = [module.topic]

  namespace   = local.namespace
  environment = local.environment
  stage       = local.stage

  aws_account_id = "123456789123"
  aws_region     = "eu-central-1"

  queues = {
    "foo" = {
      alarm = {
        create = true
      }
      queue = {
        max_receive_count = 3
      }
      subscriptions = local.subscriptions
    }
    "bar" = {
      alarm = {
        create = true
      }
      queue = {
        dead_letter_queue_create = false
      }
    }
  }
}

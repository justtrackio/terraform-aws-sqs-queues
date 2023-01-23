locals {
  namespace   = "namespace"
  environment = "environment"
  stage       = "stage"
  subscriptions = {
    "s-n-attribute1" = {
      enabled    = true
      stage      = "stage"
      name       = "name"
      attributes = ["attribute1"]
    }
  }
}

data "aws_caller_identity" "identity" {}
data "aws_region" "region" {}

module "topic" {
  source   = "github.com/justtrackio/terraform-aws-sns-topic?ref=v1.2.0"
  for_each = local.subscriptions

  alarm_create = false
  namespace    = local.namespace
  environment  = local.environment
  stage        = each.value.stage
  name         = each.value.name
  attributes   = each.value.attributes
}

module "queue" {
  source = "../.."
  providers = {
    aws             = aws
    aws.topic_owner = aws
  }

  depends_on = [module.topic]

  namespace   = local.namespace
  environment = local.environment
  stage       = local.stage

  aws_account_id = data.aws_caller_identity.identity.account_id
  aws_region     = data.aws_region.region.name

  queues = {
    "foo" = {
      alarm = {
        create = false
      }
      queue = {
        max_receive_count = 3
      }
      subscriptions = local.subscriptions
    }
  }
}

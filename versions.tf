terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.topic_owner
      ]
      version = ">= 4.45.0"
    }
  }
  required_version = ">= 1.3.6"
}

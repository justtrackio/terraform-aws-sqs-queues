provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "topic_owner"
  region = "eu-central-1"
}

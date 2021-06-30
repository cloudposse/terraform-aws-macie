terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"

      configuration_aliases = [
        aws.primary
      ]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7"
    }
  }
}

terraform {
  required_version = ">= 0.15.0"

  required_providers {
    # Update these to reflect the actual requirements of your module
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
      configuration_aliases = [
        aws.admin,
        aws
      ]
    }
  }
}

# region must be defined here so this file can be reused by module
variable "region" {
  type        = string
  description = "AWS Region"
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias = "admin"

  region = var.region
}


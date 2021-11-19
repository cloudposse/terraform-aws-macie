provider "aws" {
  region = var.region
}

provider "aws" {
  alias = "admin"

  region = var.region
}

module "example" {
  source = "../.."

  providers = {
    aws.admin = aws.admin
  }

  example = var.example

  context = module.this.context
}

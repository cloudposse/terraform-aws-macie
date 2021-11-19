provider "aws" {
  region = var.region
}

provider "aws" {
  alias = "admin"

  region = var.region
}

module "macie" {
  source = "../.."

  providers = {
    aws       = aws
    aws.admin = aws.admin
  }

  context = module.this.context
}
